import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:openvidu_client/openvidu_client.dart';

import 'drop_down.dart';
import 'media_stream_view.dart';
import 'text_field.dart';

class ConfigView extends StatefulWidget {
  final LocalParticipant participant;
  final String userName;
  final VoidCallback onConnect;
  const ConfigView({
    super.key,
    required this.onConnect,
    required this.participant,
    this.userName = '',
  });

  @override
  State<ConfigView> createState() => _ConfigViewState();
}

class _ConfigViewState extends State<ConfigView> {
  final TextEditingController _textUserNameController = TextEditingController();

  List<MediaDevice>? _audioInputs;
  List<MediaDevice>? _audioOutputs;
  List<MediaDevice>? _videoInputs;
  MediaDevice? selectedAudioInput;
  MediaDevice? selectedVideoInput;

  StreamSubscription? _subscription;

  @override
  void initState() {
    _textUserNameController.text = widget.userName;
    super.initState();
    _subscription = Hardware.instance.onDeviceChange.stream
        .listen((List<MediaDevice> devices) {
      _loadDevices(devices);
    });
    Hardware.instance.enumerateDevices().then(_loadDevices);
  }

  void _loadDevices(List<MediaDevice> devices) async {
    _audioInputs = devices.where((d) => d.kind == 'audioinput').toList();
    _audioOutputs = devices.where((d) => d.kind == 'audiooutput').toList();
    _videoInputs = devices.where((d) => d.kind == 'videoinput').toList();
    selectedAudioInput = _audioInputs?.first;
    selectedVideoInput = _videoInputs?.first;
    setState(() {});
  }

  void _selectAudioInput(MediaDevice? device) async {
    if (device == null) return;
    if (kIsWeb) {
      widget.participant.setAudioInput(device.deviceId);
    } else {
      await Hardware.instance.selectAudioInput(device);
    }
    selectedAudioInput = device;
    setState(() {});
  }

  void _selectVideoInput(MediaDevice? device) async {
    if (device == null) return;
    if (selectedVideoInput?.deviceId != device.deviceId) {
      widget.participant.setVideoInput(device.deviceId);
      selectedVideoInput = device;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Widget _controlsWidget() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OVDropDown(
            label: 'Input',
            devices: _audioInputs ?? [],
            selectDevice: selectedAudioInput,
            onChanged: _selectAudioInput,
          ),
          OVDropDown(
            label: 'Video',
            devices: _videoInputs ?? [],
            selectDevice: selectedVideoInput,
            onChanged: _selectVideoInput,
          ),
          ElevatedButton(
            onPressed: widget.onConnect,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                ),
                Text('CONNECT'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _streamWidget() {
    return MediaStreamView(
      borderRadius: BorderRadius.circular(15),
      participant: widget.participant,
    );
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: _height * 0.35,
            width: _width * 0.7,
            child: _streamWidget(),
          ),
          _controlsWidget()
        ],
      ),
    );
  }
}
