#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 802 "Online Map Management"
{

    trigger OnRun()
    begin
    end;

    var
        OnlineMapSetup: Record "Online Map Setup";
        OnlineMapParameterSetup: Record "Online Map Parameter Setup";
        ThisAddressTxt: label '&This address';
        DirectionsFromLocationTxt: label '&Directions from my location';
        OtherDirectionsTxt: label '&Other';
        OtherMenuQst: label '&Directions from my company,Directions to my &company,Directions from &another address,Directions to an&other address';
        Text002: label 'There is no default Map setup.';
        ShowMapQst: label 'Show map with:';
        Text007: label 'Table %1 has not been set up to use Online Map.';
        Text008: label 'The specified record could not be found.';
        Text015: label 'Bing Maps';


    procedure MakeSelection(TableID: Integer;Position: Text[1000])
    var
        [RunOnClient]
        LocationProvider: dotnet LocationProvider;
        MainMenu: Text;
        Selection: Integer;
    begin
        if LocationProvider.IsAvailable then
          MainMenu := StrSubstNo('%1,%2,%3',ThisAddressTxt,DirectionsFromLocationTxt,OtherDirectionsTxt)
        else
          MainMenu := StrSubstNo('%1,%2',ThisAddressTxt,OtherDirectionsTxt);

        Selection := StrMenu(MainMenu,1,ShowMapQst);
        case Selection of
          1:
            ProcessMap(TableID,Position);
          2:
            if LocationProvider.IsAvailable then
              SelectAddress(TableID,Position,4)
            else
              ShowOtherMenu(TableID,Position);
          3:
            ShowOtherMenu(TableID,Position);
        end;
    end;

    local procedure ShowOtherMenu(TableID: Integer;Position: Text[1000])
    var
        Selection: Integer;
    begin
        Selection := StrMenu(OtherMenuQst,1,ShowMapQst);
        case Selection of
          0:
            MakeSelection(TableID,Position);
          1:
            SelectAddress(TableID,Position,3);
          2:
            SelectAddress(TableID,Position,2);
          3:
            SelectAddress(TableID,Position,1);
          4:
            SelectAddress(TableID,Position,0);
        end;
    end;

    local procedure ProcessWebMap(TableNo: Integer;ToRecPosition: Text[1000])
    var
        Parameters: array [12] of Text[50];
        url: Text[1024];
    begin
        GetSetup;
        BuildParameters(TableNo,ToRecPosition,Parameters,OnlineMapSetup."Distance In",OnlineMapSetup.Route);

        url := OnlineMapParameterSetup."Map Service";
        SubstituteParameters(url,Parameters);

        Hyperlink(url);
    end;

    local procedure ProcessWebDirections(FromNo: Integer;FromRecPosition: Text[1000];ToNo: Integer;ToRecPosition: Text[1000];Distance: Option Miles,Kilometers;Route: Option Quickest,Shortest)
    var
        Parameters: array [2,12] of Text[50];
        url: Text[1024];
    begin
        GetSetup;
        BuildParameters(FromNo,FromRecPosition,Parameters[1],Distance,Route);
        BuildParameters(ToNo,ToRecPosition,Parameters[2],Distance,Route);

        if FromNo = Database::Geolocation then begin
          url := OnlineMapParameterSetup."Directions from Location Serv.";
          SubstituteGPSParameters(url,Parameters[1]);
          SubstituteParameters(url,Parameters[2]);
        end else begin
          url := OnlineMapParameterSetup."Directions Service";
          SubstituteParameters(url,Parameters[1]);
          SubstituteParameters(url,Parameters[2]);
        end;

        Hyperlink(url);
    end;

    local procedure ProcessMap(TableNo: Integer;ToRecPosition: Text[1000])
    begin
        TestSetupExists;
        ProcessWebMap(TableNo,ToRecPosition);
    end;


    procedure ProcessDirections(FromNo: Integer;FromRecPosition: Text[1000];ToNo: Integer;ToRecPosition: Text[1000];Distance: Option;Route: Option)
    begin
        TestSetupExists;
        ProcessWebDirections(FromNo,FromRecPosition,ToNo,ToRecPosition,Distance,Route);
    end;

    local procedure BuildParameters(TableNo: Integer;RecPosition: Text[1000];var Parameters: array [12] of Text[50];Distance: Option Miles,Kilometers;Route: Option Quickest,Shortest)
    var
        CompanyInfo: Record "Company Information";
        CountryRegion: Record "Country/Region";
        OnlineMapSetup: Record "Online Map Setup";
        OnlineMapParameterSetup: Record "Online Map Parameter Setup";
        i: Integer;
    begin
        Clear(Parameters);
        if ValidAddresses(TableNo) then
          GetAddress(TableNo,RecPosition,Parameters)
        else
          Error(StrSubstNo(Text007,Format(TableNo)));
        if TableNo = Database::Geolocation then
          exit;
        OnlineMapSetup.Get;
        OnlineMapSetup.TestField("Map Parameter Setup Code");
        OnlineMapParameterSetup.Get(OnlineMapSetup."Map Parameter Setup Code");
        CompanyInfo.Get;

        if Parameters[5] = '' then
          Parameters[5] := CompanyInfo."Country/Region Code";
        if CountryRegion.Get(CopyStr(Parameters[5],1,MaxStrLen(CountryRegion.Code))) then
          Parameters[6] := CountryRegion.Name;

        if OnlineMapParameterSetup."URL Encode Non-ASCII Chars" then
          for i := 1 to 6 do
            Parameters[i] := CopyStr(URLEncode(Parameters[i]),1,MaxStrLen(Parameters[i]));

        Parameters[7] := GetCultureInfo;
        if OnlineMapParameterSetup."Miles/Kilometers Option List" <> '' then
          Parameters[8] := SelectStr(Distance + 1,OnlineMapParameterSetup."Miles/Kilometers Option List");
        if OnlineMapParameterSetup."Quickest/Shortest Option List" <> '' then
          Parameters[9] := SelectStr(Route + 1,OnlineMapParameterSetup."Quickest/Shortest Option List");
    end;

    local procedure GetAddress(TableID: Integer;RecPosition: Text[1000];var Parameters: array [12] of Text[50])
    var
        Geolocation: Record Geolocation;
        Location: Record Location;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        RecordRef.Open(TableID);
        RecordRef.SetPosition(RecPosition);
        if not RecordRef.Find('=') then
          Error(Text008);

        case TableID of
          Database::Location:
            begin
              RecordRef.SetTable(Location);
              Parameters[1] := Format(Location.Address);
              Parameters[2] := Format(Location.City);
              Parameters[3] := Format(Location.County);
              Parameters[4] := Format(Location."Post Code");
              Parameters[5] := Format(Location."Country/Region Code");
            end;
          Database::Customer:
            begin
              FieldRef := RecordRef.Field(5);
              Parameters[1] := Format(FieldRef);
              FieldRef := RecordRef.Field(7);
              Parameters[2] := Format(FieldRef);
              FieldRef := RecordRef.Field(92);
              Parameters[3] := Format(FieldRef);
              FieldRef := RecordRef.Field(91);
              Parameters[4] := Format(FieldRef);
              FieldRef := RecordRef.Field(35);
              Parameters[5] := Format(FieldRef);
            end;
          Database::Vendor:
            begin
              FieldRef := RecordRef.Field(5);
              Parameters[1] := Format(FieldRef);
              FieldRef := RecordRef.Field(7);
              Parameters[2] := Format(FieldRef);
              FieldRef := RecordRef.Field(92);
              Parameters[3] := Format(FieldRef);
              FieldRef := RecordRef.Field(91);
              Parameters[4] := Format(FieldRef);
              FieldRef := RecordRef.Field(35);
              Parameters[5] := Format(FieldRef);
            end;
          Database::"Company Information":
            begin
              FieldRef := RecordRef.Field(4);
              Parameters[1] := Format(FieldRef);
              FieldRef := RecordRef.Field(6);
              Parameters[2] := Format(FieldRef);
              FieldRef := RecordRef.Field(31);
              Parameters[3] := Format(FieldRef);
              FieldRef := RecordRef.Field(30);
              Parameters[4] := Format(FieldRef);
              FieldRef := RecordRef.Field(36);
              Parameters[5] := Format(FieldRef);
            end;
          Database::Resource:
            begin
              FieldRef := RecordRef.Field(6);
              Parameters[1] := Format(FieldRef);
              FieldRef := RecordRef.Field(8);
              Parameters[2] := Format(FieldRef);
              FieldRef := RecordRef.Field(54);
              Parameters[3] := Format(FieldRef);
              FieldRef := RecordRef.Field(53);
              Parameters[4] := Format(FieldRef);
              FieldRef := RecordRef.Field(59);
              Parameters[5] := Format(FieldRef);
            end;
          Database::Job:
            begin
              FieldRef := RecordRef.Field(59);
              Parameters[1] := Format(FieldRef);
              FieldRef := RecordRef.Field(61);
              Parameters[2] := Format(FieldRef);
              FieldRef := RecordRef.Field(63);
              Parameters[3] := Format(FieldRef);
              FieldRef := RecordRef.Field(64);
              Parameters[4] := Format(FieldRef);
              FieldRef := RecordRef.Field(67);
              Parameters[5] := Format(FieldRef);
            end;
          Database::"Ship-to Address":
            begin
              FieldRef := RecordRef.Field(5);
              Parameters[1] := Format(FieldRef);
              FieldRef := RecordRef.Field(7);
              Parameters[2] := Format(FieldRef);
              FieldRef := RecordRef.Field(92);
              Parameters[3] := Format(FieldRef);
              FieldRef := RecordRef.Field(91);
              Parameters[4] := Format(FieldRef);
              FieldRef := RecordRef.Field(35);
              Parameters[5] := Format(FieldRef);
            end;
          Database::"Order Address":
            begin
              FieldRef := RecordRef.Field(5);
              Parameters[1] := Format(FieldRef);
              FieldRef := RecordRef.Field(7);
              Parameters[2] := Format(FieldRef);
              FieldRef := RecordRef.Field(92);
              Parameters[3] := Format(FieldRef);
              FieldRef := RecordRef.Field(91);
              Parameters[4] := Format(FieldRef);
              FieldRef := RecordRef.Field(35);
              Parameters[5] := Format(FieldRef);
            end;
          Database::"Bank Account":
            begin
              FieldRef := RecordRef.Field(5);
              Parameters[1] := Format(FieldRef);
              FieldRef := RecordRef.Field(7);
              Parameters[2] := Format(FieldRef);
              FieldRef := RecordRef.Field(92);
              Parameters[3] := Format(FieldRef);
              FieldRef := RecordRef.Field(91);
              Parameters[4] := Format(FieldRef);
              FieldRef := RecordRef.Field(35);
              Parameters[5] := Format(FieldRef);
            end;
          Database::Contact:
            begin
              FieldRef := RecordRef.Field(5);
              Parameters[1] := Format(FieldRef);
              FieldRef := RecordRef.Field(7);
              Parameters[2] := Format(FieldRef);
              FieldRef := RecordRef.Field(92);
              Parameters[3] := Format(FieldRef);
              FieldRef := RecordRef.Field(91);
              Parameters[4] := Format(FieldRef);
              FieldRef := RecordRef.Field(35);
              Parameters[5] := Format(FieldRef);
            end;
          Database::o:
            begin
              FieldRef := RecordRef.Field(8);
              Parameters[1] := Format(FieldRef);
              FieldRef := RecordRef.Field(10);
              Parameters[2] := Format(FieldRef);
              FieldRef := RecordRef.Field(12);
              Parameters[3] := Format(FieldRef);
              FieldRef := RecordRef.Field(11);
              Parameters[4] := Format(FieldRef);
              FieldRef := RecordRef.Field(25);
              Parameters[5] := Format(FieldRef);
            end;
          Database::Geolocation:
            begin
              RecordRef.SetTable(Geolocation);
              Parameters[10] := Format(Geolocation.Latitude,0,2);
              Parameters[11] := Format(Geolocation.Longitude,0,2);
            end;
        end;
    end;

    local procedure ValidAddresses(TableID: Integer): Boolean
    begin
        exit(
          (TableID in
           [Database::"Bank Account",
            Database::"Company Information",
            Database::Contact,
            Database::Customer,
            Database::o,
            Database::Job,
            Database::Location,
            Database::Resource,
            Database::"Ship-to Address",
            Database::"Order Address",
            Database::Vendor,
            Database::Geolocation]));
    end;

    local procedure URLEncode(InText: Text[250]): Text[250]
    var
        SystemWebHttpUtility: dotnet HttpUtility;
    begin
        SystemWebHttpUtility := SystemWebHttpUtility.HttpUtility;
        exit(CopyStr(SystemWebHttpUtility.UrlEncodeUnicode(InText),1,MaxStrLen(InText)));
    end;

    local procedure GetCultureInfo(): Text[30]
    var
        CultureInfo: dotnet CultureInfo;
    begin
        CultureInfo := CultureInfo.CultureInfo(WindowsLanguage);
        exit(CopyStr(CultureInfo.ToString,1,30));
    end;

    local procedure TestSetupExists(): Boolean
    var
        OnlineMapSetup: Record "Online Map Setup";
    begin
        if not OnlineMapSetup.Get then
          Error(Text002);
        exit(true);
    end;


    procedure TestSetup(): Boolean
    var
        OnlineMapSetup: Record "Online Map Setup";
    begin
        exit(not OnlineMapSetup.IsEmpty);
    end;

    local procedure SelectAddress(TableNo: Integer;RecPosition: Text[1000];Direction: Option "To Other","From Other","To Company","From Company","From my location")
    var
        CompanyInfo: Record "Company Information";
        OnlineMapSetup: Record "Online Map Setup";
        OnlineMapAddressSelector: Page "Online Map Address Selector";
        OnlineMapLocation: Page "Online Map Location";
        Distance: Option Miles,Kilometers;
        Route: Option Quickest,Shortest;
    begin
        if Direction in [Direction::"To Other",Direction::"From Other"] then begin
          if not (OnlineMapAddressSelector.RunModal = Action::OK) then
            exit;
          if OnlineMapAddressSelector.GetRecPosition = '' then
            exit;
          OnlineMapAddressSelector.Getdefaults(Distance,Route)
        end else begin
          OnlineMapSetup.Get;
          CompanyInfo.Get;
        end;

        case Direction of
          Direction::"To Other":
            ProcessDirections(
              TableNo,RecPosition,
              OnlineMapAddressSelector.GetTableNo,OnlineMapAddressSelector.GetRecPosition,
              Distance,Route);
          Direction::"From Other":
            ProcessDirections(
              OnlineMapAddressSelector.GetTableNo,OnlineMapAddressSelector.GetRecPosition,
              TableNo,RecPosition,
              Distance,Route);
          Direction::"To Company":
            ProcessDirections(
              TableNo,RecPosition,
              Database::"Company Information",CompanyInfo.GetPosition,
              OnlineMapSetup."Distance In",OnlineMapSetup.Route);
          Direction::"From Company":
            ProcessDirections(
              Database::"Company Information",CompanyInfo.GetPosition,
              TableNo,RecPosition,
              OnlineMapSetup."Distance In",OnlineMapSetup.Route);
          Direction::"From my location":
            begin
              OnlineMapLocation.SetRecordTo(TableNo,RecPosition);
              OnlineMapLocation.RunModal;
            end;
        end;
    end;

    local procedure SubstituteParameters(var url: Text[1024];Parameters: array [12] of Text[50])
    var
        ParameterName: Text;
        parameterNumber: Integer;
        ParmPos: Integer;
    begin
        for parameterNumber := 1 to ArrayLen(Parameters) do begin
          ParameterName := StrSubstNo('{%1}',parameterNumber);
          ParmPos := StrPos(url,ParameterName);

          if ParmPos > 1 then
            url :=
              CopyStr(
                CopyStr(url,1,ParmPos - 1) + Parameters[parameterNumber] + CopyStr(url,ParmPos + StrLen(ParameterName)),
                1,MaxStrLen(url));
        end;
    end;

    local procedure SubstituteGPSParameters(var url: Text[1024];Parameters: array [12] of Text[50])
    var
        ParameterName: Text;
        parameterNumber: Integer;
        ParmPos: Integer;
    begin
        for parameterNumber := 10 to ArrayLen(Parameters) do begin
          ParameterName := StrSubstNo('{%1}',parameterNumber);
          ParmPos := StrPos(url,ParameterName);

          if ParmPos > 1 then
            url :=
              CopyStr(
                CopyStr(url,1,ParmPos - 1) + Parameters[parameterNumber] + CopyStr(url,ParmPos + StrLen(ParameterName)),
                1,MaxStrLen(url));
        end;
    end;


    procedure SetupDefault()
    var
        OnlineMapSetup: Record "Online Map Setup";
        OnlineMapParameterSetup: Record "Online Map Parameter Setup";
    begin
        OnlineMapSetup.DeleteAll;
        OnlineMapParameterSetup.DeleteAll;
        InsertParam(
          'BING',
          Text015,
          'http://bing.com/maps/default.aspx?where1={1}+{2}+{6}&v=2&mkt={7}',
          'http://bing.com/maps/default.aspx?rtp=adr.{1}+{2}+{6}~adr.{1}+{2}+{6}&v=2&mkt={7}&rtop={9}~0~0',
          'http://bing.com/maps/default.aspx?rtp=pos.{10}_{11}~adr.{1}+{2}+{6}&v=2&mkt={7}&rtop={9}~0~0',
          false,'','0,1',
          'http://go.microsoft.com/fwlink/?LinkId=519372');
        OnlineMapSetup."Map Parameter Setup Code" := 'BING';
        OnlineMapSetup.Insert;
    end;

    local procedure InsertParam("Code": Code[10];Name: Text[30];MapURL: Text[250];DirectionsURL: Text[250];DirectionsFromGpsURL: Text[250];URLEncode: Boolean;MilesKilometres: Text[250];QuickesShortest: Text[250];Comment: Text[250])
    var
        OnlineMapParameterSetup: Record "Online Map Parameter Setup";
    begin
        OnlineMapParameterSetup.Init;
        OnlineMapParameterSetup.Code := Code;
        OnlineMapParameterSetup.Name := Name;
        OnlineMapParameterSetup."Map Service" := MapURL;
        OnlineMapParameterSetup."Directions Service" := DirectionsURL;
        OnlineMapParameterSetup."Directions from Location Serv." := DirectionsFromGpsURL;
        OnlineMapParameterSetup."URL Encode Non-ASCII Chars" := URLEncode;
        OnlineMapParameterSetup."Miles/Kilometers Option List" := MilesKilometres;
        OnlineMapParameterSetup."Quickest/Shortest Option List" := QuickesShortest;
        OnlineMapParameterSetup.Comment := Comment;
        OnlineMapParameterSetup.Insert(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Service Connection", 'OnRegisterServiceConnection', '', false, false)]

    procedure HandleMAPRegisterServiceConnection(var ServiceConnection: Record "Service Connection")
    var
        OnlineMapSetup: Record "Online Map Setup";
        RecRef: RecordRef;
    begin
        if not OnlineMapSetup.Get then begin
          if not OnlineMapSetup.WritePermission then
            exit;
          OnlineMapSetup.Init;
          OnlineMapSetup.Insert;
        end;
        RecRef.GetTable(OnlineMapSetup);

        ServiceConnection.Status := ServiceConnection.Status::Enabled;
        with OnlineMapSetup do begin
          if "Map Parameter Setup Code" = '' then
            ServiceConnection.Status := ServiceConnection.Status::Disabled;
          ServiceConnection.InsertServiceConnection(
            ServiceConnection,RecRef.RecordId,TableCaption,'',Page::"Online Map Setup");
        end;
    end;

    local procedure GetSetup()
    begin
        OnlineMapSetup.Get;
        OnlineMapSetup.TestField("Map Parameter Setup Code");
        OnlineMapParameterSetup.Get(OnlineMapSetup."Map Parameter Setup Code");
    end;
}

