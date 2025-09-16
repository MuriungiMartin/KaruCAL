#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 806 "Online Map Location"
{
    Caption = 'Online Map Location';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    ShowFilter = false;

    layout
    {
        area(content)
        {
            field(GeolocationLbl;GeolocationLbl)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Status';
                Importance = Promoted;
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        if not LocationProvider.IsAvailable then begin
          Message(LocationNotAvailableMsg);
          CurrPage.Close;
          exit;
        end;
        LocationProvider := LocationProvider.Create;
        LocationProvider.RequestLocationAsync;
    end;

    var
        [RunOnClient]
        [WithEvents]
        LocationProvider: dotnet LocationProvider;
        ToTableNo: Integer;
        ToRecordPosition: Text[1000];
        GeolocationLbl: label 'Searching for your location.';
        LocationNotAvailableMsg: label 'Your location cannot be determined.';


    procedure SetRecordTo(NewToTableNo: Integer;NewToRecordPosition: Text[1000])
    begin
        ToTableNo := NewToTableNo;
        ToRecordPosition := NewToRecordPosition;
    end;

    trigger Locationprovider::LocationChanged(location: dotnet Location)
    var
        OnlineMapSetup: Record "Online Map Setup";
        Geolocation: Record Geolocation;
        OnlineMapManagement: Codeunit "Online Map Management";
    begin
        if location.Status <> 0 then begin
          Message(LocationNotAvailableMsg);
          CurrPage.Close;
          exit;
        end;

        Geolocation.Init;
        Geolocation.ID := CreateGuid;
        Geolocation.Latitude := location.Coordinate.Latitude;
        Geolocation.Longitude := location.Coordinate.Longitude;
        Geolocation.Insert;

        if not OnlineMapSetup.Get then begin
          OnlineMapManagement.SetupDefault;
          OnlineMapSetup.Get;
        end;

        OnlineMapManagement.ProcessDirections(
          Database::Geolocation,Geolocation.GetPosition,
          ToTableNo,ToRecordPosition,
          OnlineMapSetup."Distance In",OnlineMapSetup.Route);

        Geolocation.Delete;
        CurrPage.Close;
    end;
}

