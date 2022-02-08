
import 'package:mobile_controller/config/command_config.dart';
import 'package:mobile_controller/model/execute_result.dart';
import 'package:mobile_controller/utils/log_helper.dart';
import '../config/file_config.dart';
import '../utils/file_utils.dart';

/// Controller to manage command executions.
/// @author Dorck
/// @date 2022/02/08
class CommandController {

  // Execute commands of adb.
  static Future<ExecutionResult> executeAdbCommand(AdbCommand command, {
    String executable = '',
    String extArguments = '',
    bool synchronous = false,
    bool runInShell = false,
    String? workingDirectory
  }) async {
    await checkEnv(executable: extArguments);
    var executor = CommandConfig.adbCommandExecutors[command];
    if (executor != null) {
      var commandStr = executor.fullCommand;
      if (command == AdbCommand.customized) {
        logI('customized command: $extArguments', tag: 'CommandController');
      } else {
        logI('execute command: $commandStr', tag: 'CommandController');
      }
      return executor.execute(executable: executable,
          extArguments: extArguments,
          synchronous: synchronous,
          runInShell: runInShell,
          workingDirectory: workingDirectory);
    } else {
      throw CommandRunException(message: 'can not find command: $command');
    }
  }

  // Check the environment of adb execution.
  static Future<void> checkEnv({String executable = ""}) async {
    if (FileConfig.adbPath == "") {
      throw CommandRunException(message: 'adb path can not be empty.');
    }
    if (!await FileUtils.isExistFile(executable)) {
      throw CommandRunException(message: 'you must set executable path to run the command');
    }
  }

}