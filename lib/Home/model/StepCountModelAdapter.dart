import 'package:hive/hive.dart';
import 'package:travel_go/Home/model/StepCountModel.dart';


class StepCountModelAdapter extends TypeAdapter<StepCountModel> {
  @override
  final int typeId = 0;

  @override
  StepCountModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StepCountModel(
      stepCount: fields[0] as int,
      date: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StepCountModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.stepCount)
      ..writeByte(1)
      ..write(obj.date);
  }
}