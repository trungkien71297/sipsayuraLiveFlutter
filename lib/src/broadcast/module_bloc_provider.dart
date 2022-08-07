import 'package:bbb_app/src/broadcast/mute_bloc.dart';
import 'package:bbb_app/src/broadcast/snackbar_bloc.dart';
import 'package:bbb_app/src/broadcast/user_voice_status_bloc.dart';

class ModuleBlocProvider {
  late SnackbarCubit snackbarCubit;
  late UserVoiceStatusBloc userVoiceStatusBloc;
  late MuteBloc muteBloc;
}
