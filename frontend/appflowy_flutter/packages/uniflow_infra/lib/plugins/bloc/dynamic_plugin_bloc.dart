import 'package:bloc/bloc.dart';
import 'package:uniflow_infra/plugins/service/models/exceptions.dart';
import 'package:uniflow_infra/plugins/service/plugin_service.dart';

import '../../file_picker/file_picker_impl.dart';

import 'dynamic_plugin_event.dart';
import 'dynamic_plugin_state.dart';

class DynamicPluginBloc extends Bloc<DynamicPluginEvent, DynamicPluginState> {
  DynamicPluginBloc({FilePicker? filePicker})
      : super(const DynamicPluginState.uninitialized()) {
    on<DynamicPluginEvent>(dispatch);
    add(DynamicPluginEvent.load());
  }

  Future<void> dispatch(
      DynamicPluginEvent event, Emitter<DynamicPluginState> emit) async {
    await event.when(
      addPlugin: () => addPlugin(emit),
      removePlugin: (name) => removePlugin(emit, name),
      load: () => onLoadRequested(emit),
    );
  }

  Future<void> onLoadRequested(Emitter<DynamicPluginState> emit) async {
    emit(
      DynamicPluginState.ready(
        plugins: await UniflowPluginService.instance.plugins,
      ),
    );
  }

  Future<void> addPlugin(Emitter<DynamicPluginState> emit) async {
    emit(const DynamicPluginState.processing());
    try {
      final plugin = await UniflowPluginService.pick();
      if (plugin == null) {
        return emit(
          DynamicPluginState.ready(
            plugins: await UniflowPluginService.instance.plugins,
          ),
        );
      }
      await UniflowPluginService.instance.addPlugin(plugin);
    } on PluginCompilationException catch (exception) {
      return emit(
        DynamicPluginState.compilationFailure(errorMessage: exception.message),
      );
    }

    emit(const DynamicPluginState.compilationSuccess());
    emit(
      DynamicPluginState.ready(
        plugins: await UniflowPluginService.instance.plugins,
      ),
    );
  }

  Future<void> removePlugin(
    Emitter<DynamicPluginState> emit,
    String name,
  ) async {
    emit(const DynamicPluginState.processing());

    final plugin = await UniflowPluginService.instance.lookup(name: name);

    if (plugin == null) {
      return emit(
        DynamicPluginState.ready(
          plugins: await UniflowPluginService.instance.plugins,
        ),
      );
    }

    await UniflowPluginService.removePlugin(plugin);

    emit(const DynamicPluginState.deletionSuccess());
    emit(
      DynamicPluginState.ready(
        plugins: await UniflowPluginService.instance.plugins,
      ),
    );
  }
}
