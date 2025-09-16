#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1872 "Item Availability Check"
{
    AutoSplitKey = false;
    Caption = 'Availability check';
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    MultipleNewLines = false;
    PopulateAllFields = false;
    PromotedActionCategories = 'New,Process,Report,Manage';
    SaveValues = false;
    ShowFilter = true;
    SourceTable = Item;
    SourceTableTemporary = false;

    layout
    {
        area(content)
        {
            label(Control2)
            {
                ApplicationArea = Basic,Suite;
                CaptionClass = Heading;
            }
            field(InventoryQty;InventoryQty)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Available Inventory';
                DecimalPlaces = 0:5;
                Editable = false;
                ToolTip = 'Specifies the quantity of the item that is currently in inventory and not reserved for other demand.';
            }
            field(TotalQuantity;TotalQuantity)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Inventory Shortage';
                DecimalPlaces = 0:5;
                Editable = false;
                ToolTip = 'Specifies the total quantity of the item that is currently in inventory. The Total Quantity field is used to calculate the Available Inventory field as follows: Available Inventory = Total Quantity - Reserved Quantity.';
            }
            part(AvailabilityCheckDetails;"Item Availability Check Det.")
            {
                ApplicationArea = Basic,Suite;
                Editable = false;
                SubPageLink = "No."=field("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Manage")
            {
                Caption = '&Manage';
                action("Page Item Card")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Item';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = false;
                    PromotedOnly = true;
                    RunObject = Page "Item Card";
                    RunPageLink = "No."=field("No."),
                                  "Date Filter"=field("Date Filter"),
                                  "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter"=field("Global Dimension 2 Filter");
                    RunPageMode = View;
                    ToolTip = 'View details of the Item';
                }
            }
            group(Create)
            {
                Caption = 'Create';
                action("Purchase Invoice")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Create Purchase Invoice';
                    Image = NewPurchaseInvoice;
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = false;
                    PromotedOnly = true;
                    ToolTip = 'Create Purchase Invoice';

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                        PurchaseLine: Record "Purchase Line";
                        Vendor: Record Vendor;
                    begin
                        if "Vendor No." = '' then begin
                          if not SelectVendor(Vendor) then
                            exit;

                          "Vendor No." := Vendor."No."
                        end;
                        PurchaseHeader.Init;
                        PurchaseHeader.Validate("Document Type",PurchaseHeader."document type"::Invoice);
                        PurchaseHeader.Insert(true);
                        PurchaseHeader.Validate("Buy-from Vendor No.","Vendor No.");
                        PurchaseHeader.Modify(true);

                        PurchaseLine.Init;
                        PurchaseLine.Validate("Document Type",PurchaseHeader."Document Type");
                        PurchaseLine.Validate("Document No.",PurchaseHeader."No.");
                        PurchaseLine.Validate("Line No.",10000);
                        PurchaseLine.Insert(true);

                        PurchaseLine.Validate(Type,PurchaseLine.Type::Item);
                        PurchaseLine.Validate("No.","No.");

                        PurchaseLine.Modify(true);
                        Page.Run(Page::"Purchase Invoice",PurchaseHeader);
                    end;
                }
            }
        }
    }

    var
        TotalQuantity: Decimal;
        InventoryQty: Decimal;
        Heading: Text;
        SelectVentorTxt: label 'Select a vendor to buy from.';


    procedure PopulateDataOnNotification(var AvailabilityCheckNotification: Notification;ItemNo: Code[20];UnitOfMeasureCode: Code[20];InventoryQty: Decimal;GrossReq: Decimal;ReservedReq: Decimal;SchedRcpt: Decimal;ReservedRcpt: Decimal;CurrentQuantity: Decimal;CurrentReservedQty: Decimal;TotalQuantity: Decimal;EarliestAvailDate: Date)
    begin
        AvailabilityCheckNotification.SetData('ItemNo',ItemNo);
        AvailabilityCheckNotification.SetData('UnitOfMeasureCode',UnitOfMeasureCode);
        AvailabilityCheckNotification.SetData('GrossReq',Format(GrossReq));
        AvailabilityCheckNotification.SetData('ReservedReq',Format(ReservedReq));
        AvailabilityCheckNotification.SetData('SchedRcpt',Format(SchedRcpt));
        AvailabilityCheckNotification.SetData('ReservedRcpt',Format(ReservedRcpt));
        AvailabilityCheckNotification.SetData('CurrentQuantity',Format(CurrentQuantity));
        AvailabilityCheckNotification.SetData('CurrentReservedQty',Format(CurrentReservedQty));
        AvailabilityCheckNotification.SetData('TotalQuantity',Format(TotalQuantity));
        AvailabilityCheckNotification.SetData('InventoryQty',Format(InventoryQty));
        AvailabilityCheckNotification.SetData('EarliestAvailDate',Format(EarliestAvailDate));
    end;


    procedure InitializeFromNotification(AvailabilityCheckNotification: Notification)
    var
        GrossReq: Decimal;
        SchedRcpt: Decimal;
        ReservedReq: Decimal;
        ReservedRcpt: Decimal;
        CurrentQuantity: Decimal;
        CurrentReservedQty: Decimal;
        EarliestAvailDate: Date;
    begin
        Get(AvailabilityCheckNotification.GetData('ItemNo'));
        SetRange("No.",AvailabilityCheckNotification.GetData('ItemNo'));
        Evaluate(TotalQuantity,AvailabilityCheckNotification.GetData('TotalQuantity'));
        Evaluate(InventoryQty,AvailabilityCheckNotification.GetData('InventoryQty'));
        CurrPage.AvailabilityCheckDetails.Page.SetUnitOfMeasureCode(
          AvailabilityCheckNotification.GetData('UnitOfMeasureCode'));

        if AvailabilityCheckNotification.GetData('GrossReq') <> '' then begin
          Evaluate(GrossReq,AvailabilityCheckNotification.GetData('GrossReq'));
          CurrPage.AvailabilityCheckDetails.Page.SetGrossReq(GrossReq);
        end;
        if AvailabilityCheckNotification.GetData('ReservedReq') <> '' then begin
          Evaluate(ReservedReq,AvailabilityCheckNotification.GetData('ReservedReq'));
          CurrPage.AvailabilityCheckDetails.Page.SetReservedReq(ReservedReq);
        end;
        if AvailabilityCheckNotification.GetData('SchedRcpt') <> '' then begin
          Evaluate(SchedRcpt,AvailabilityCheckNotification.GetData('SchedRcpt'));
          CurrPage.AvailabilityCheckDetails.Page.SetSchedRcpt(SchedRcpt);
        end;
        if AvailabilityCheckNotification.GetData('ReservedRcpt') <> '' then begin
          Evaluate(ReservedRcpt,AvailabilityCheckNotification.GetData('ReservedRcpt'));
          CurrPage.AvailabilityCheckDetails.Page.SetReservedRcpt(ReservedRcpt);
        end;
        if AvailabilityCheckNotification.GetData('CurrentQuantity') <> '' then begin
          Evaluate(CurrentQuantity,AvailabilityCheckNotification.GetData('CurrentQuantity'));
          CurrPage.AvailabilityCheckDetails.Page.SetCurrentQuantity(CurrentQuantity);
        end;
        if AvailabilityCheckNotification.GetData('CurrentReservedQty') <> '' then begin
          Evaluate(CurrentReservedQty,AvailabilityCheckNotification.GetData('CurrentReservedQty'));
          CurrPage.AvailabilityCheckDetails.Page.SetCurrentReservedQty(CurrentReservedQty);
        end;
        if AvailabilityCheckNotification.GetData('EarliestAvailDate') <> '' then begin
          Evaluate(EarliestAvailDate,AvailabilityCheckNotification.GetData('EarliestAvailDate'));
          CurrPage.AvailabilityCheckDetails.Page.SetEarliestAvailDate(EarliestAvailDate);
        end;
    end;


    procedure SetHeading(Value: Text)
    begin
        Heading := Value;
    end;

    local procedure SelectVendor(var Vendor: Record Vendor): Boolean
    var
        VendorList: Page "Vendor List";
    begin
        VendorList.LookupMode(true);
        VendorList.Caption(SelectVentorTxt);
        if VendorList.RunModal = Action::LookupOK then begin
          VendorList.GetRecord(Vendor);
          exit(true);
        end;

        exit(false);
    end;
}

