/*
*	Part of the Oxygen Engine / Sonic 3 A.I.R. software distribution.
*	Copyright (C) 2017-2022 by Eukaryot
*
*	Published under the GNU GPLv3 open source software license, see license.txt
*	or https://www.gnu.org/licenses/gpl-3.0.en.html
*/

#include "lemon/pch.h"
#include "lemon/program/Function.h"
#include "lemon/program/Module.h"
#include "lemon/runtime/Runtime.h"
#include "lemon/compiler/Utility.h"


namespace lemon
{
	namespace detail
	{
		// This data hasher implementation uses a mixture of Murmur2 (which is faster for larger chunks of memory)
		// and FNV1a (which can be used to accumulate the chunk hashes easily)
		//  -> TODO: Some accumulative implementation of Murmur2 would be nice for this
		//  -> TODO: Move this somewhere else?
		struct QuickDataHasher
		{
			uint64 mHash = 0;
			uint8 mChunk[0x1000];
			size_t mSize = 0;

			QuickDataHasher()
			{
				mHash = rmx::startFNV1a_64();
			}

			explicit QuickDataHasher(uint64 initialHash) :
				mHash(initialHash)
			{
			}

			uint64 getHash()
			{
				flush();
				return mHash;
			}

			void flush()
			{
				if (mSize > 0)
				{
					uint64 chunkHash = rmx::getMurmur2_64(mChunk, mSize);
					mHash = rmx::addToFNV1a_64(mHash, (uint8*)&chunkHash, sizeof(chunkHash));
					mSize = 0;
				}
			}

			void prepareNextData(size_t maximumExpectedSize)
			{
				if (mSize + maximumExpectedSize > 0x1000)
				{
					flush();
				}
			}

			void addData(uint8 value)
			{
				mChunk[mSize] = value;
				++mSize;
			}

			void addData(uint64 value)
			{
				memcpy(&mChunk[mSize], &value, sizeof(value));
				++mSize;
			}
		};

		uint32 getVoidSignatureHash()
		{
			uint32 value = PredefinedDataTypes::VOID.getDataTypeHash();
			return rmx::getFNV1a_32((const uint8*)&value, sizeof(uint32));
		}
	}


	void Function::setParametersByTypes(const std::vector<const DataTypeDefinition*>& parameterTypes)
	{
		mParameters.clear();
		mParameters.resize(parameterTypes.size());
		for (size_t i = 0; i < parameterTypes.size(); ++i)
		{
			mParameters[i].mType = parameterTypes[i];
		}
		mSignatureHash = 0;
	}

	uint32 Function::getVoidSignatureHash()
	{
		static const uint32 signatureHash = detail::getVoidSignatureHash();
		return signatureHash;
	}

	uint32 Function::getSignatureHash() const
	{
		if (mSignatureHash == 0)
		{
			static std::vector<uint32> data;
			data.clear();
			data.push_back(mReturnType->getDataTypeHash());
			for (const Parameter& parameter : mParameters)
			{
				data.push_back(parameter.mType->getDataTypeHash());
			}

			mSignatureHash = rmx::getFNV1a_32((const uint8*)&data[0], data.size() * sizeof(uint32));
			while (mSignatureHash == 0)		// That should be a really rare case anyway
			{
				data.push_back(0xcd000000);		// Just add anything to get away from hash 0
				mSignatureHash = rmx::getFNV1a_32((const uint8*)&data[0], data.size() * sizeof(uint32));
			}
		}
		return mSignatureHash;
	}


	ScriptFunction::~ScriptFunction()
	{
		for (LocalVariable* variable : mLocalVariablesByID)
		{
			mModule->destroyLocalVariable(*variable);
		}
	}

	LocalVariable* ScriptFunction::getLocalVariableByIdentifier(uint64 nameHash) const
	{
		const auto it = mLocalVariablesByIdentifier.find(nameHash);
		return (it == mLocalVariablesByIdentifier.end()) ? nullptr : it->second;
	}

	LocalVariable& ScriptFunction::getLocalVariableByID(uint32 id) const
	{
		return *mLocalVariablesByID[id];
	}

	LocalVariable& ScriptFunction::addLocalVariable(std::string_view identifier, uint64 nameHash, const DataTypeDefinition* dataType, uint32 lineNumber)
	{
		// Check if it already exists!
		if (mLocalVariablesByIdentifier.count(nameHash))
		{
			CHECK_ERROR(false, "Variable already exists", lineNumber);
		}

		LocalVariable& variable = mModule->createLocalVariable();
		variable.mName = identifier;
		variable.mNameHash = nameHash;
		variable.mDataType = dataType;

		mLocalVariablesByIdentifier.emplace(nameHash, &variable);

		variable.mID = (uint32)mLocalVariablesByID.size();
		mLocalVariablesByID.emplace_back(&variable);

		return variable;
	}

	bool ScriptFunction::getLabel(std::string_view labelName, size_t& outOffset) const
	{
		const auto it = mLabels.find(std::string(labelName));
		if (it == mLabels.end())
			return false;

		outOffset = it->second;
		return true;
	}

	void ScriptFunction::addLabel(std::string_view labelName, size_t offset)
	{
		mLabels[std::string(labelName)] = (uint32)offset;
	}

	const std::string* ScriptFunction::findLabelByOffset(size_t offset) const
	{
		// Note that this won't handle multipe labels at the same position too well
		for (const auto& pair : mLabels)
		{
			if (pair.second == offset)
			{
				return &pair.first;
			}
		}
		return nullptr;
	}

	uint64 ScriptFunction::addToCompiledHash(uint64 hash) const
	{
		detail::QuickDataHasher dataHasher(hash);
		for (const Opcode& opcode : mOpcodes)
		{
			dataHasher.prepareNextData(10);
			dataHasher.addData((uint8)opcode.mType);
			dataHasher.addData((uint8)opcode.mDataType);
			if (opcode.mParameter != 0)
				dataHasher.addData((uint64)opcode.mParameter);
		}
		return dataHasher.getHash();
	}


	void UserDefinedFunction::setFunction(const FunctionWrapper& functionWrapper)
	{
		mFunctionWrapper = &functionWrapper;
		mReturnType = functionWrapper.getReturnType();
		setParametersByTypes(functionWrapper.getParameterTypes());
	}

	UserDefinedFunction& UserDefinedFunction::setParameterInfo(size_t index, const std::string& identifier)
	{
		RMX_ASSERT(index < mParameters.size(), "Invalid parameter index " << index);
		RMX_ASSERT(mParameters[index].mIdentifier.empty(), "Parameter identifier is already set for index " << index);
		mParameters[index].mIdentifier = identifier;
		mParameters[index].mNameHash = rmx::getMurmur2_64(identifier);
		return *this;
	}

	void UserDefinedFunction::execute(const Context context) const
	{
		RuntimeDetailHandler* runtimeDetailHandler = context.mControlFlow.getRuntime().getRuntimeDetailHandler();
		if (nullptr != runtimeDetailHandler)
		{
			runtimeDetailHandler->preExecuteExternalFunction(*this, context.mControlFlow);
			mFunctionWrapper->execute(context);
			runtimeDetailHandler->postExecuteExternalFunction(*this, context.mControlFlow);
		}
		else
		{
			mFunctionWrapper->execute(context);
		}
	}

}
