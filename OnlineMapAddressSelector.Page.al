#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 802 "Online Map Address Selector"
{
    Caption = 'Online Map Address Selector';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(LookupSelection;LookupSelection)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Table Selection';
                    OptionCaption = ' ,Bank,Contact,Customer,Employee,Job,Location,Resource,Vendor,Ship-to Address,Order Address';

                    trigger OnValidate()
                    begin
                        LookupSelectionOnAfterValidate;
                    end;
                }
                field(LookupCode;LookupCode)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Lookup Code';
                    ToolTip = 'Specifies a list of contact, customer, or location codes to choose from.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        SelectedRecPosition := LoadLocationLookup(SelectedTableNo,LookupCode,true);
                    end;

                    trigger OnValidate()
                    begin
                        SelectedRecPosition := LoadLocationLookup(SelectedTableNo,LookupCode,false);
                    end;
                }
                field(Distance;Distance)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Distance In';
                    OptionCaption = 'Miles,Kilometers';
                    ToolTip = 'Specifies if distances on the online map are shown in miles or kilometers.';
                }
                field(Route;Route)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Route';
                    OptionCaption = 'Quickest,Shortest';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        OnlineMapSetup.Get;
        Distance := OnlineMapSetup."Distance In";
        Route := OnlineMapSetup.Route;
    end;

    var
        OnlineMapSetup: Record "Online Map Setup";
        SelectedRecPosition: Text[1000];
        LookupCode: Code[20];
        LookupSelection: Option " ",Bank,Contact,Customer,Employee,Job,Location,Resource,Vendor,"Ship-to Address","Order Address";
        Text001: label 'The selection that was chosen is not valid.';
        Text003: label 'The value %1 from Table ID %2 could not be found.';
        Distance: Option Miles,Kilometers;
        Route: Option Quickest,Shortest;
        SelectedTableNo: Integer;
        Text004: label 'Table No. %1 is not set up.';


    procedure GetTableNo(): Integer
    begin
        exit(SelectedTableNo);
    end;


    procedure GetRecPosition(): Text[1000]
    begin
        exit(SelectedRecPosition);
    end;


    procedure SetTableNo()
    begin
        case LookupSelection of
          Lookupselection::" ":
            SelectedTableNo := 0;
          Lookupselection::Bank:
            SelectedTableNo := Database::"Bank Account";
          Lookupselection::Contact:
            SelectedTableNo := Database::Contact;
          Lookupselection::Customer:
            SelectedTableNo := Database::Customer;
          Lookupselection::Employee:
            SelectedTableNo := Database::o;
          Lookupselection::Job:
            SelectedTableNo := Database::Job;
          Lookupselection::Location:
            SelectedTableNo := Database::Location;
          Lookupselection::Resource:
            SelectedTableNo := Database::Resource;
          Lookupselection::Vendor:
            SelectedTableNo := Database::Vendor;
          Lookupselection::"Ship-to Address":
            SelectedTableNo := Database::"Ship-to Address";
          Lookupselection::"Order Address":
            SelectedTableNo := Database::"Order Address";
          else
            Error(Text001);
        end;
    end;

    local procedure LoadLocationLookup(LoadTableNo: Integer;var LookupCode: Code[20];Lookup: Boolean): Text[1000]
    begin
        case LoadTableNo of
          Database::"Bank Account":
            exit(LoadBankAccount(LookupCode,Lookup));
          Database::Contact:
            exit(LoadContact(LookupCode,Lookup));
          Database::Customer:
            exit(LoadCustomer(LookupCode,Lookup));
          Database::o:
            exit(LoadEmployee(LookupCode,Lookup));
          Database::Job:
            exit(LoadJob(LookupCode,Lookup));
          Database::Location:
            exit(LoadLocation(LookupCode,Lookup));
          Database::Resource:
            exit(LoadResource(LookupCode,Lookup));
          Database::Vendor:
            exit(LoadVendor(LookupCode,Lookup));
          Database::"Ship-to Address":
            exit(LoadShipTo(LookupCode,Lookup));
          Database::"Order Address":
            exit(LoadOrderAddress(LookupCode,Lookup));
          else
            Error(StrSubstNo(Text004,Format(LoadTableNo)));
        end;
    end;

    local procedure LoadBankAccount(var LookUpCode: Code[20];LookUp: Boolean): Text[1000]
    var
        BankAccount: Record "Bank Account";
        Response: Boolean;
    begin
        if LookUp then
          Response := Page.RunModal(Page::"Bank Account List",BankAccount) = Action::LookupOK
        else
          Response := BankAccount.Get(LookUpCode);

        if Response then begin
          LookUpCode := BankAccount."No.";
          exit(BankAccount.GetPosition);
        end;
        Error(Text003,LookUpCode,Database::"Bank Account");
    end;

    local procedure LoadContact(var LookUpCode: Code[20];LookUp: Boolean): Text[1000]
    var
        Contact: Record Contact;
        Response: Boolean;
    begin
        if LookUp then
          Response := Page.RunModal(Page::"Contact List",Contact) = Action::LookupOK
        else
          Response := Contact.Get(LookUpCode);

        if Response then begin
          LookUpCode := Contact."No.";
          exit(Contact.GetPosition);
        end;
        Error(Text003,LookUpCode,Database::Contact);
    end;

    local procedure LoadCustomer(var LookUpCode: Code[20];LookUp: Boolean): Text[1000]
    var
        Customer: Record Customer;
        Response: Boolean;
    begin
        if LookUp then
          Response := Page.RunModal(Page::"Customer List",Customer) = Action::LookupOK
        else
          Response := Customer.Get(LookUpCode);

        if Response then begin
          LookUpCode := Customer."No.";
          exit(Customer.GetPosition);
        end;
        Error(Text003,LookUpCode,Database::Customer);
    end;

    local procedure LoadEmployee(var LookUpCode: Code[20];LookUp: Boolean): Text[1000]
    var
        Employee: Record Employee;
        Response: Boolean;
    begin
        if LookUp then
          Response := Page.RunModal(Page::"Employee List",Employee) = Action::LookupOK
        else
          Response := Employee.Get(LookUpCode);

        if Response then begin
          LookUpCode := Employee."No.";
          exit(Employee.GetPosition);
        end;
        Error(Text003,LookUpCode,Database::o);
    end;

    local procedure LoadJob(var LookUpCode: Code[20];LookUp: Boolean): Text[1000]
    var
        Job: Record Job;
        Response: Boolean;
    begin
        if LookUp then
          Response := Page.RunModal(Page::"Job List",Job) = Action::LookupOK
        else
          Response := Job.Get(LookUpCode);

        if Response then begin
          LookUpCode := Job."No.";
          exit(Job.GetPosition);
        end;
        Error(Text003,LookUpCode,Database::Job);
    end;

    local procedure LoadLocation(var LookUpCode: Code[20];LookUp: Boolean): Text[1000]
    var
        Location: Record Location;
        Response: Boolean;
    begin
        if LookUp then
          Response := Page.RunModal(Page::"Location List",Location) = Action::LookupOK
        else
          Response := Location.Get(LookUpCode);

        if Response then begin
          LookUpCode := Location.Code;
          exit(Location.GetPosition);
        end;
        Error(Text003,LookUpCode,Database::Location);
    end;

    local procedure LoadResource(var LookUpCode: Code[20];LookUp: Boolean): Text[1000]
    var
        Resource: Record Resource;
        Response: Boolean;
    begin
        if LookUp then
          Response := Page.RunModal(Page::"Resource List",Resource) = Action::LookupOK
        else
          Response := Resource.Get(LookUpCode);

        if Response then begin
          LookUpCode := Resource."No.";
          exit(Resource.GetPosition);
        end;
        Error(Text003,LookUpCode,Database::Resource);
    end;

    local procedure LoadVendor(var LookUpCode: Code[20];LookUp: Boolean): Text[1000]
    var
        Vendor: Record Vendor;
        Response: Boolean;
    begin
        if LookUp then
          Response := Page.RunModal(Page::"Vendor List",Vendor) = Action::LookupOK
        else
          Response := Vendor.Get(LookUpCode);

        if Response then begin
          LookUpCode := Vendor."No.";
          exit(Vendor.GetPosition);
        end;
        Error(Text003,LookUpCode,Database::Vendor);
    end;

    local procedure LoadShipTo(var LookUpCode: Code[20];LookUp: Boolean): Text[1000]
    var
        ShipToAddress: Record "Ship-to Address";
        Response: Boolean;
    begin
        if LookUp then
          Response := Page.RunModal(Page::"Ship-to Address List",ShipToAddress) = Action::LookupOK
        else
          Response := ShipToAddress.Get(LookUpCode);

        if Response then begin
          LookUpCode := ShipToAddress.Code;
          exit(ShipToAddress.GetPosition);
        end;
        Error(Text003,LookUpCode,Database::"Ship-to Address");
    end;

    local procedure LoadOrderAddress(var LookupCode: Code[20];LookUp: Boolean): Text[1000]
    var
        OrderAddress: Record "Order Address";
        Response: Boolean;
    begin
        if LookUp then
          Response := Page.RunModal(Page::"Order Address List",OrderAddress) = Action::LookupOK
        else
          Response := OrderAddress.Get(LookupCode);

        if Response then begin
          LookupCode := OrderAddress.Code;
          exit(OrderAddress.GetPosition);
        end;
        Error(Text003,LookupCode,Database::"Order Address");
    end;


    procedure Getdefaults(var ActualDistance: Option Miles,Kilometers;var ActualRoute: Option Quickest,Shortest)
    begin
        ActualDistance := Distance;
        ActualRoute := Route;
    end;

    local procedure LookupSelectionOnAfterValidate()
    begin
        SetTableNo;
    end;
}

