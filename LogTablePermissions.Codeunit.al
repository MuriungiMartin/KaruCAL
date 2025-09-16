#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 9800 "Log Table Permissions"
{
    EventSubscriberInstance = Manual;
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        TempTablePermissionBuffer: Record "Table Permission Buffer" temporary;
        [WithEvents]
        EventReceiver: dotnet NavPermissionEventReceiver;


    procedure Start()
    begin
        TempTablePermissionBuffer.DeleteAll;
        if IsNull(EventReceiver) then
          EventReceiver := EventReceiver.NavPermissionEventReceiver(SessionId);

        EventReceiver.RegisterForEvents;
    end;


    procedure Stop(var TempTablePermissionBufferVar: Record "Table Permission Buffer" temporary)
    begin
        EventReceiver.UnregisterEvents;
        TempTablePermissionBufferVar.Copy(TempTablePermissionBuffer,true)
    end;

    local procedure LogUsage(TypeOfObject: Option;ObjectId: Integer;Permissions: Integer;PermissionsFromCaller: Integer)
    begin
        // Note: Do not start any write transactions inside this method and do not make
        // any commits. This code is invoked on permission checks - where there may be
        // no transaction.
        if (ObjectId = Database::"Table Permission Buffer") and
           ((TypeOfObject = TempTablePermissionBuffer."object type"::Table) or
            (TypeOfObject = TempTablePermissionBuffer."object type"::"Table Data") or
            ((TypeOfObject = TempTablePermissionBuffer."object type"::Codeunit) and (ObjectId = Codeunit::"Log Table Permissions")))
        then
          exit;

        if not TempTablePermissionBuffer.Get(SessionId,TypeOfObject,ObjectId) then begin
          TempTablePermissionBuffer.Init;
          TempTablePermissionBuffer."Session ID" := SessionId;
          TempTablePermissionBuffer."Object Type" := TypeOfObject;
          TempTablePermissionBuffer."Object ID" := ObjectId;
          TempTablePermissionBuffer."Read Permission" := TempTablePermissionBuffer."read permission"::" ";
          TempTablePermissionBuffer."Insert Permission" := TempTablePermissionBuffer."insert permission"::" ";
          TempTablePermissionBuffer."Modify Permission" := TempTablePermissionBuffer."modify permission"::" ";
          TempTablePermissionBuffer."Delete Permission" := TempTablePermissionBuffer."delete permission"::" ";
          TempTablePermissionBuffer."Execute Permission" := TempTablePermissionBuffer."execute permission"::" ";
          TempTablePermissionBuffer.Insert;
        end;

        TempTablePermissionBuffer."Object Type" := TypeOfObject;

        case SelectDirectOrIndirect(Permissions,PermissionsFromCaller) of
          1:
            TempTablePermissionBuffer."Read Permission" :=
              GetMaxPermission(TempTablePermissionBuffer."Read Permission",TempTablePermissionBuffer."read permission"::Yes);
          32:
            TempTablePermissionBuffer."Read Permission" :=
              GetMaxPermission(TempTablePermissionBuffer."Read Permission",TempTablePermissionBuffer."read permission"::Indirect);
          2:
            TempTablePermissionBuffer."Insert Permission" :=
              GetMaxPermission(TempTablePermissionBuffer."Insert Permission",TempTablePermissionBuffer."insert permission"::Yes);
          64:
            TempTablePermissionBuffer."Insert Permission" :=
              GetMaxPermission(TempTablePermissionBuffer."Insert Permission",TempTablePermissionBuffer."insert permission"::Indirect);
          4:
            TempTablePermissionBuffer."Modify Permission" :=
              GetMaxPermission(TempTablePermissionBuffer."Modify Permission",TempTablePermissionBuffer."modify permission"::Yes);
          128:
            TempTablePermissionBuffer."Modify Permission" :=
              GetMaxPermission(TempTablePermissionBuffer."Modify Permission",TempTablePermissionBuffer."modify permission"::Indirect);
          8:
            TempTablePermissionBuffer."Delete Permission" :=
              GetMaxPermission(TempTablePermissionBuffer."Delete Permission",TempTablePermissionBuffer."delete permission"::Yes);
          256:
            TempTablePermissionBuffer."Delete Permission" :=
              GetMaxPermission(TempTablePermissionBuffer."Delete Permission",TempTablePermissionBuffer."delete permission"::Indirect);
          16:
            TempTablePermissionBuffer."Execute Permission" :=
              GetMaxPermission(TempTablePermissionBuffer."Execute Permission",TempTablePermissionBuffer."execute permission"::Yes);
          512:
            TempTablePermissionBuffer."Execute Permission" :=
              GetMaxPermission(TempTablePermissionBuffer."Execute Permission",TempTablePermissionBuffer."execute permission"::Indirect);
        end;
        TempTablePermissionBuffer.Modify;
    end;


    procedure GetMaxPermission(CurrentPermission: Option;NewPermission: Option): Integer
    var
        Permission: Record Permission;
    begin
        if (CurrentPermission = Permission."read permission"::Indirect) and (NewPermission = Permission."read permission"::Indirect) then
          exit(Permission."read permission"::Indirect);
        if CurrentPermission = Permission."read permission"::" " then
          exit(NewPermission);
        exit(CurrentPermission);
    end;

    local procedure SelectDirectOrIndirect(DirectPermission: Integer;IndirectPermission: Integer): Integer
    begin
        if IndirectPermission = 0 then
          exit(DirectPermission);
        exit(IndirectPermission);
    end;

    trigger Eventreceiver::OnPermissionCheckEvent(sender: Variant;e: dotnet PermissionCheckEventArgs)
    begin
        case e.EventId of
          801,804:
            LogUsage(e.ObjectType,e.ObjectId,e.Permissions,e.IndirectPermissionsFromCaller);
        end;
    end;
}

