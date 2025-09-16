#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50074 "Bid Analysis Worksheet"
{
    DeleteAllowed = false;
    PageType = Worksheet;
    SourceTable = UnknownTable61550;

    layout
    {
        area(content)
        {
            group(Control1102755012)
            {
                field(SalesCodeFilterCtrl;SalesCodeFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendor Code Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        VendList: Page "Vendor List";
                    begin
                         begin
                           VendList.LookupMode := true;
                           if VendList.RunModal = Action::LookupOK then
                             Text := VendList.GetSelectionFilter
                           else
                            exit(false);
                        end;

                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        SalesCodeFilterOnAfterValidate;
                    end;
                }
                field(ItemNoFilter;ItemNoFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item No.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemList: Page "Item List";
                    begin
                        ItemList.LookupMode := true;
                        if ItemList.RunModal = Action::LookupOK then
                          Text := ItemList.GetSelectionFilter
                         else
                          exit(false);

                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        ItemNoFilterOnAfterValidate;
                    end;
                }
                field(Total;Total)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            repeater(Group)
            {
                field("RFQ No.";"RFQ No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("RFQ Line No.";"RFQ Line No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Quote No.";"Quote No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Vendor No.";"Vendor No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(VendorName;VendorName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendor Name';
                    Editable = false;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Unit Of Measure";"Unit Of Measure")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Line Amount";"Line Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Get Vendor Quotations")
            {
                ApplicationArea = Basic;
                Caption = 'Get Vendor Quotations';
                Image = GetSourceDoc;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                    GetVendorQuotes;
                end;
            }
            action(Print)
            {
                ApplicationArea = Basic;
                Caption = 'Print';
                Image = Report2;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Bid Analysis";

                trigger OnAction()
                begin
                    BidAnalysis.Reset;
                    BidAnalysis.SetRange("RFQ No.","RFQ No.");
                    //RFQ No.,RFQ Line No.,Quote No.,Vendor No.
                    if BidAnalysis.FindFirst then
                    Report.Run(Report::"Bid Analysis",true,false,BidAnalysis);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Vendor.Get("Vendor No.");
        VendorName:=Vendor.Name;
        CalcTotals;
    end;

    var
        PurchHeader: Record "Purchase Header";
        PurchLines: Record "Purchase Line";
        ItemNoFilter: Text[250];
        RFQNoFilter: Text[250];
        InsertCount: Integer;
        SalesCodeFilter: Text[250];
        VendorName: Text;
        Vendor: Record Vendor;
        Total: Decimal;
        BidAnalysis: Record UnknownRecord61550;


    procedure SetRecFilters()
    begin
        if SalesCodeFilter <> '' then
          SetFilter("Vendor No.",SalesCodeFilter)
        else
          SetRange("Vendor No.");

        if ItemNoFilter <> '' then begin
          SetFilter("Item No.",ItemNoFilter);
        end else
          SetRange("Item No.");

        CalcTotals;

        CurrPage.Update(false);
    end;

    local procedure ItemNoFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;


    procedure GetVendorQuotes()
    begin
        //insert the quotes from vendors
        if RFQNoFilter = '' then Error('Specify the RFQ No.');

        PurchHeader.SetRange("RFQ No.",RFQNoFilter);
        PurchHeader.FindSet;
        repeat
          PurchLines.Reset;
          PurchLines.SetRange("Document No.",PurchHeader."No.");
          if PurchLines.FindSet then
          repeat
            Init;
            "RFQ No.":=PurchHeader."RFQ No.";
            "RFQ Line No.":=PurchLines."Line No.";
            "Quote No.":=PurchLines."Document No.";
            "Vendor No.":=PurchLines."Buy-from Vendor No.";
            "Item No.":=PurchLines."No.";
            Description:=PurchLines.Description;
            Quantity:=PurchLines.Quantity;
            "Unit Of Measure":=PurchLines."Unit of Measure";
            Amount:=PurchLines."Direct Unit Cost";
         //   "Vat Amount":=PurchLines."VAT Amount";
            "Line Amount":=Quantity*Amount;
            Insert(true);
            InsertCount:=+1;
           until PurchLines.Next=0;
        until PurchHeader.Next=0;
        Message('%1 records have been inserted to the bid analysis');
    end;

    local procedure SalesCodeFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;


    procedure CalcTotals()
    var
        BidAnalysisRec: Record UnknownRecord61550;
    begin
        BidAnalysisRec.SetRange("RFQ No.","RFQ No.");
        if SalesCodeFilter <>'' then
        BidAnalysisRec.SetRange("Vendor No.",SalesCodeFilter);
        if ItemNoFilter <> '' then
        BidAnalysisRec.SetRange("Item No.",ItemNoFilter);
        BidAnalysisRec.FindSet;
        BidAnalysisRec.CalcSums("Line Amount");
        Total:=BidAnalysisRec."Line Amount";
    end;
}

