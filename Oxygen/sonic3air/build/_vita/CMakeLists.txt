cmake_minimum_required(VERSION 3.14)

if (NOT DEFINED ENV{VITASDK} AND NOT DEFINED CMAKE_TOOLCHAIN_FILE)
  message(FATAL_ERROR "Please define VITASDK env var to point to your SDK path or set CMAKE_TOOLCHAIN_FILE.")
endif ()

set(CMAKE_TOOLCHAIN_FILE "$ENV{VITASDK}/share/vita.toolchain.cmake" CACHE PATH "Toolchain file")

project(sonic3air C CXX)

include("${VITASDK}/share/vita.cmake" REQUIRED)

# Vita application configuration
set(VITA_APP_NAME "Sonic 3 A.I.R.")
set(VITA_TITLEID "SAIR30000")
set(VITA_VPKNAME "sonic3air")
set(VITA_VERSION "01.10")
set(VITA_MKSFOEX_FLAGS "-d ATTRIBUTE2=12")

# Optional: used for "send" and "dump" targets
set(PSVITAIP "192.168.0.198" CACHE STRING "PSVita IP (for FTP access)")
set(PARSECOREPATH "$ENV{PARSECOREPATH}" CACHE STRING "vita-parse-core main.py")

if (CMAKE_BUILD_TYPE STREQUAL "Debug")
  add_definitions(-DDEBUG)
endif()

set(SONIC_FLAGS "-DARM -march=armv7-a -mfpu=neon -mfloat-abi=hard -D__vita__ -D__arm__ -g -O1 -fno-inline-functions -fno-inline-functions-called-once -fno-optimize-sibling-calls -fno-default-inline -fsigned-char -mno-unaligned-access")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${SONIC_FLAGS}")
set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} -std=gnu++20 -Wno-psabi ${SONIC_FLAGS}")

find_package(SDL2)

add_executable(${CMAKE_PROJECT_NAME}
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/pch.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/compiler/Compiler.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/compiler/LineNumberTranslation.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/compiler/Node.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/compiler/Operators.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/compiler/Preprocessor.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/compiler/Token.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/compiler/TokenHelper.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/compiler/TypeCasting.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/compiler/backend/FunctionCompiler.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/compiler/frontend/CompilerFrontend.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/compiler/frontend/TokenProcessing.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/compiler/parser/Parser.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/compiler/parser/ParserHelper.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/program/BaseType.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/program/ConstantArray.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/program/DataType.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/program/Define.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/program/Function.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/program/FunctionWrapper.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/program/GlobalsLookup.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/program/Module.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/program/ModuleSerializer.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/program/Opcode.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/program/Program.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/program/StringRef.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/runtime/BuiltInFunctions.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/runtime/ControlFlow.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/runtime/OpcodeProcessor.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/runtime/Runtime.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/runtime/RuntimeFunction.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/runtime/StandardLibrary.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/runtime/provider/DefaultOpcodeProvider.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/runtime/provider/NativizedOpcodeProvider.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/runtime/provider/OptimizedOpcodeProvider.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/translator/Nativizer.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/translator/NativizerInternal.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/translator/SourceCodeWriter.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/translator/Translator.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/utility/FlyweightString.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source/lemon/utility/PragmaSplitter.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/pch.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/Application.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/Configuration.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/EngineMain.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/GameLoader.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/GameProfile.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/audio/AudioCollection.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/audio/AudioOutBase.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/audio/AudioPlayer.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/audio/AudioSourceBase.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/audio/AudioSourceManager.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/audio/EmulationAudioSource.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/audio/OggAudioSource.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/input/ControlsIn.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/input/InputConfig.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/input/InputManager.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/input/InputRecorder.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/input/RumbleEffectQueue.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/mainview/GameView.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/menu/GameSetupScreen.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/menu/MenuItems.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/menu/OxygenMenu.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/modding/Mod.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/modding/ModManager.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/overlays/BackdropView.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/overlays/CheatSheetOverlay.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/overlays/DebugLogView.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/overlays/DebugSidePanel.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/overlays/DebugSidePanelCategory.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/overlays/MemoryHexView.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/overlays/ProfilingView.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/overlays/SaveStateMenu.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/overlays/TouchControlsOverlay.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/application/video/VideoOut.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/download/Downloader.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/download/DownloadManager.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/drawing/DrawCollection.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/drawing/DrawCommand.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/drawing/Drawer.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/drawing/DrawerTexture.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/drawing/opengl/OpenGLDrawer.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/drawing/opengl/OpenGLDrawerResources.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/drawing/opengl/OpenGLDrawerTexture.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/drawing/opengl/OpenGLSpriteTextureManager.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/drawing/opengl/OpenGLTexture.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/drawing/opengl/Upscaler.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/drawing/software/Blitter.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/drawing/software/SoftwareDrawer.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/drawing/software/SoftwareDrawerTexture.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/drawing/software/SoftwareRasterizer.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/file/FilePackage.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/file/FileStructureTree.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/file/PackedFileProvider.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/file/ZipFileProvider.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/helper/BitStream.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/helper/FileHelper.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/helper/HighResolutionTimer.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/helper/JsonHelper.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/helper/Logging.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/helper/Profiling.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/helper/TextInputHandler.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/helper/Transform2D.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/helper/Utils.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/platform/AndroidJavaInterface.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/platform/CrashHandler.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/platform/PlatformFunctions.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/rendering/Geometry.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/rendering/RenderResources.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/rendering/opengl/OpenGLRenderer.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/rendering/opengl/OpenGLRenderResources.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/rendering/opengl/shaders/DebugDrawPlaneShader.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/rendering/opengl/shaders/OpenGLShader.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/rendering/opengl/shaders/RenderComponentSpriteShader.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/rendering/opengl/shaders/RenderPaletteSpriteShader.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/rendering/opengl/shaders/RenderPlaneShader.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/rendering/opengl/shaders/RenderVdpSpriteShader.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/rendering/parts/PaletteManager.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/rendering/parts/PatternManager.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/rendering/parts/PlaneManager.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/rendering/parts/RenderItem.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/rendering/parts/RenderParts.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/rendering/parts/ScrollOffsetsManager.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/rendering/parts/SpriteManager.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/rendering/software/SoftwareRenderer.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/rendering/sprite/ComponentSprite.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/rendering/sprite/PaletteSprite.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/rendering/sprite/SpriteDump.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/rendering/utils/BufferTexture.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/rendering/utils/Kosinski.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/rendering/utils/PaletteBitmap.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/rendering/utils/RenderUtils.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/resources/FontCollection.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/resources/PrintedTextCache.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/resources/ResourcesCache.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/resources/SpriteCache.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/simulation/CodeExec.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/simulation/EmulatorInterface.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/simulation/GameRecorder.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/simulation/LemonScriptProgram.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/simulation/LemonScriptRuntime.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/simulation/LogDisplay.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/simulation/PersistentData.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/simulation/SaveStateSerializer.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/simulation/Simulation.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/simulation/analyse/ROMDataAnalyser.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/simulation/bindings/LemonScriptBindings.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/simulation/bindings/RendererBindings.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/simulation/debug/DebugTracking.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/simulation/sound/blip_buf.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/simulation/sound/sn76489.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/simulation/sound/SoundDriver.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/simulation/sound/SoundEmulation.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen/simulation/sound/ym2612.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen_netcore/pch.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen_netcore/network/ConnectionManager.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen_netcore/network/NetConnection.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen_netcore/network/RequestBase.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen_netcore/network/ServerClientBase.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen_netcore/network/Sockets.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen_netcore/network/internal/CryptoFunctions.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen_netcore/network/internal/ReceivedPacketCache.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen_netcore/network/internal/SentPacketCache.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen_netcore/network/internal/WebSocketClient.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source/oxygen_netcore/network/internal/WebSocketWrapper.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/ConfigurationImpl.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/EngineDelegate.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/Game.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/main.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/pch.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/_nativized/NativizedCode.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/audio/AudioOut.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/audio/CustomAudioMixer.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/audio/RemasteredMusicDownload.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/client/GameClient.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/client/GhostSync.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/client/UpdateCheck.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/client/crowdcontrol/CrowdControlClient.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/data/PlayerProgress.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/data/PlayerRecorder.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/data/SharedDatabase.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/data/TimeAttackData.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/generator/ResourceScriptGenerator.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/helper/BlueSpheresRendering.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/helper/CommandForwarder.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/helper/DiscordIntegration.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/helper/DrawingUtils.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/helper/GameUtils.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/helper/PackageBuilder.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/menu/ActSelectMenu.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/menu/ExtrasMenu.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/menu/GameApp.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/menu/GameMenuBase.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/menu/GameMenuManager.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/menu/MainMenu.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/menu/MenuBackground.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/menu/PauseMenu.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/menu/SharedResources.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/menu/TimeAttackMenu.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/menu/TimeAttackResultsMenu.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/menu/context/ApplicationContextMenu.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/menu/entries/GeneralMenuEntries.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/menu/helper/GameMenuControlsDisplay.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/menu/helper/GameMenuScrolling.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/menu/mods/ModsMenu.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/menu/mods/ModsMenuEntries.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/menu/options/ControllerSetupMenu.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/menu/options/OptionsConfig.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/menu/options/OptionsEntry.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/menu/options/OptionsMenu.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/menu/options/OptionsMenuEntries.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/menu/overlays/SecretUnlockedWindow.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/menu/overlays/SkippableCutsceneWindow.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/resources/DynamicSprites.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/scriptimpl/ScriptImplementations.cpp
  ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source/sonic3air/platform/vita/trophies.c
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/_jsoncpp/json_reader.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/_jsoncpp/json_value.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/_jsoncpp/json_writer.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/rmxbase.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/base/Basics.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/base/ErrorHandler.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/bitmap/Bitmap.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/bitmap/BitmapCodecBMP.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/bitmap/BitmapCodecICO.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/bitmap/BitmapCodecJPG.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/bitmap/BitmapCodecPNG.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/bitmap/Color.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/file/FileCrawler.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/file/FileHandle.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/file/FileIO.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/file/FileProvider.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/file/FileSystem.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/file/JsonHelper.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/file/RealFileProvider.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/math/Math.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/memory/BinarySerializer.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/memory/InputStream.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/memory/OneTimeAllocPool.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/memory/OutputStream.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/memory/RC4Encryption.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/memory/RmxDeflate.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/memory/String.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/memory/UnalignedMemory.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/memory/UTF8Conversion.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/memory/VectorBinarySerializer.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/memory/ZlibDeflate.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/tools/Logging.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxbase/tools/Tools.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxext_oggvorbis/OggLoader.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxext_oggvorbis/rmxext_oggvorbis.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxmedia/rmxmedia.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxmedia/audiovideo/AudioBuffer.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxmedia/audiovideo/AudioManager.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxmedia/audiovideo/AudioMixer.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxmedia/audiovideo/AudioReference.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxmedia/audiovideo/VideoBuffer.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxmedia/file/FileInputStreamSDL.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxmedia/file/FileProviderSDL.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxmedia/font/Font.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxmedia/font/FontProcessor.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxmedia/font/FontSource.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxmedia/framework/AppFramework.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxmedia/framework/FTX_System.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxmedia/framework/GuiBase.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxmedia/opengl/Framebuffer.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxmedia/opengl/GLTools.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxmedia/opengl/OpenGLFontOutput.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxmedia/opengl/Painter.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxmedia/opengl/Shader.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxmedia/opengl/SpriteAtlas.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxmedia/opengl/Texture.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxmedia/opengl/VertexArrayObject.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxmedia/threads/JobManager.cpp
  ${CMAKE_SOURCE_DIR}/../../../../librmx/source/rmxmedia/threads/Thread.cpp)

target_include_directories(${CMAKE_PROJECT_NAME}
                           PUBLIC ${CMAKE_SOURCE_DIR}/../../../../Oxygen/lemonscript/source
                           PUBLIC ${CMAKE_SOURCE_DIR}/../../../../Oxygen/oxygenengine/source
                           PUBLIC ${CMAKE_SOURCE_DIR}/../../../../Oxygen/sonic3air/source
                           PUBLIC ${CMAKE_SOURCE_DIR}/../../../../librmx/source
                           )

target_link_libraries(${CMAKE_PROJECT_NAME}
                      vorbis ogg minizip bz2 zstd SceNpTrophy_stub
                      SDL2::SDL2 vitaGL vitashark mathneon SceDisplay_stub SceGxm_stub
                      SceNet_stub SceNetCtl_stub SceAppUtil_stub SceSysmodule_stub
                      SceCtrl_stub SceHid_stub SceTouch_stub SceAudio_stub SceShaccCgExt
                      taihen_stub SceKernelDmacMgr_stub ScePower_stub SceRtc_stub
                      SceCommonDialog_stub ScePgf_stub SceMotion_stub SceFiber_stub
                      SceMotion_stub SceAppMgr_stub SceShaccCg_stub stdc++
                      -Wl,--whole-archive pthread -Wl,--no-whole-archive png z m c
                      )

vita_create_self(eboot.bin ${CMAKE_PROJECT_NAME} UNSAFE NOASLR)
vita_create_vpk(${VITA_VPKNAME}.vpk ${VITA_TITLEID} eboot.bin
                VERSION ${VITA_VERSION}
                NAME ${VITA_APP_NAME}
                FILE ${CMAKE_SOURCE_DIR}/../../___internal/sce_sys/icon0.png sce_sys/icon0.png
                ${CMAKE_SOURCE_DIR}/../../___internal/sce_sys/pic0.png sce_sys/pic0.png
                ${CMAKE_SOURCE_DIR}/../../___internal/sce_sys/livearea/contents/startup.png sce_sys/livearea/contents/startup.png
                ${CMAKE_SOURCE_DIR}/../../___internal/sce_sys/livearea/contents/bg0.png sce_sys/livearea/contents/bg0.png
                ${CMAKE_SOURCE_DIR}/../../___internal/sce_sys/livearea/contents/template.xml sce_sys/livearea/contents/template.xml
                ${CMAKE_SOURCE_DIR}/../../___internal/sce_sys/trophy/SAIR30000_00/TROPHY.TRP sce_sys/trophy/SAIR30000_00/TROPHY.TRP
                )

add_custom_target(send
                  COMMAND echo destroy | nc ${PSVITAIP} 1338
                  COMMAND echo destroy | nc ${PSVITAIP} 1338
                  COMMAND curl -T eboot.bin ftp://${PSVITAIP}:1337/ux0:/app/${VITA_TITLEID}/
                  COMMAND echo launch ${VITA_TITLEID} | nc ${PSVITAIP} 1338
                  DEPENDS ${VITA_VPKNAME}.vpk-vpk
                  )

add_custom_target(dump
                  COMMAND ${CMAKE_SOURCE_DIR}/extras/scripts/get_dump.sh ${PSVITAIP}
                  COMMAND python3 ${PARSECOREPATH} coredump ${CMAKE_PROJECT_NAME}
                  )
