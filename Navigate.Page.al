#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 344 Navigate
{
    ApplicationArea = Basic;
    Caption = 'Navigate';
    DataCaptionExpression = GetCaptionText;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    PromotedActionCategories = 'New,Process,Report,Find By';
    SaveValues = false;
    SourceTable = "Document Entry";
    SourceTableTemporary = true;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(Document)
            {
                Caption = 'Document';
                Visible = DocumentVisible;
                field(DocNoFilter;DocNoFilter)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Document No.';
                    ToolTip = 'Specifies the document number of an entry that is used to find all documents that have the same document number. You can enter a new document number in this field to search for another set of documents.';

                    trigger OnValidate()
                    begin
                        SetDocNo(DocNoFilter);
                        ContactType := Contacttype::" ";
                        ContactNo := '';
                        ExtDocNo := '';
                        ClearTrackingInfo;
                        DocNoFilterOnAfterValidate;
                        FilterSelectionChanged;
                    end;
                }
                field(PostingDateFilter;PostingDateFilter)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies the posting date for the document that you are searching for. You can insert a filter if you want to search for a certain interval of dates.';

                    trigger OnValidate()
                    begin
                        SetPostingDate(PostingDateFilter);
                        ContactType := Contacttype::" ";
                        ContactNo := '';
                        ExtDocNo := '';
                        ClearTrackingInfo;
                        PostingDateFilterOnAfterValida;
                        FilterSelectionChanged;
                    end;
                }
            }
            group("Business Contact")
            {
                Caption = 'Business Contact';
                Visible = BusinessContactVisible;
                field(ContactType;ContactType)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Business Contact Type';
                    OptionCaption = ' ,Vendor,Customer,Bank Account';
                    ToolTip = 'Specifies if you want to search for customers, vendors, or bank accounts. Your choice determines the list that you can access in the Business Contact No. field.';

                    trigger OnValidate()
                    begin
                        NavigateDeposit := (ContactType = Contacttype::"Bank Account");
                        SetDocNo('');
                        SetPostingDate('');
                        ClearTrackingInfo;
                        ContactTypeOnAfterValidate;
                        FilterSelectionChanged;
                    end;
                }
                field(ContactNo;ContactNo)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Business Contact No.';
                    ToolTip = 'Specifies the number of the customer, vendor, or bank account that you want to find entries for.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Vend: Record Vendor;
                        Cust: Record Customer;
                        BankAcc: Record "Bank Account";
                    begin
                        case ContactType of
                          Contacttype::Vendor:
                            if Page.RunModal(0,Vend) = Action::LookupOK then begin
                              Text := Vend."No.";
                              exit(true);
                            end;
                          Contacttype::Customer:
                            if Page.RunModal(0,Cust) = Action::LookupOK then begin
                              Text := Cust."No.";
                              exit(true);
                            end;
                          Contacttype::"Bank Account":
                            if Page.RunModal(0,BankAcc) = Action::LookupOK then begin
                              Text := BankAcc."No.";
                              exit(true);
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        SetDocNo('');
                        SetPostingDate('');
                        ClearTrackingInfo;
                        ContactNoOnAfterValidate;
                        FilterSelectionChanged;
                    end;
                }
                field(ExtDocNo;ExtDocNo)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'External Document No.';
                    ToolTip = 'Specifies the document number assigned by the vendor.';

                    trigger OnValidate()
                    begin
                        SetDocNo('');
                        SetPostingDate('');
                        ClearTrackingInfo;
                        ExtDocNoOnAfterValidate;
                        FilterSelectionChanged;
                    end;
                }
            }
            group("Item Reference")
            {
                Caption = 'Item Reference';
                Visible = ItemReferenceVisible;
                field(SerialNoFilter;SerialNoFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Serial No.';
                    ToolTip = 'Specifies the posting date of the document when you have opened the Navigate window from the document. The entry''s document number is shown in the Document No. field.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        SerialNoInformationList: Page "Serial No. Information List";
                    begin
                        Clear(SerialNoInformationList);
                        if SerialNoInformationList.RunModal = Action::LookupOK then begin
                          Text := SerialNoInformationList.GetSelectionFilter;
                          exit(true);
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        ClearInfo;
                        SerialNoFilterOnAfterValidate;
                        FilterSelectionChanged;
                    end;
                }
                field(LotNoFilter;LotNoFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Lot No.';
                    ToolTip = 'Specifies the number that you want to find entries for.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        LotNoInformationList: Page "Lot No. Information List";
                    begin
                        Clear(LotNoInformationList);
                        if LotNoInformationList.RunModal = Action::LookupOK then begin
                          Text := LotNoInformationList.GetSelectionFilter;
                          exit(true);
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        ClearInfo;
                        LotNoFilterOnAfterValidate;
                        FilterSelectionChanged;
                    end;
                }
            }
            group(Notification)
            {
                Caption = 'Notification';
                InstructionalText = 'The filter has been changed. Choose Find to update the list of related entries.';
                Visible = FilterSelectionChangedTxtVisible;
            }
            repeater(Control16)
            {
                Editable = false;
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the entry number that is assigned to the entry.';
                    Visible = false;
                }
                field("Table ID";"Table ID")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the table that the entry is stored in.';
                    Visible = false;
                }
                field("Table Name";"Table Name")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Related Entries';
                    ToolTip = 'Specifies the name of the table where the Navigate facility has found entries with the selected document number and/or posting date.';
                }
                field("No. of Records";"No. of Records")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'No. of Entries';
                    DrillDown = true;
                    ToolTip = 'Specifies the number of documents that the Navigate facility has found in the table with the selected entries.';

                    trigger OnDrillDown()
                    begin
                        ShowRecords;
                    end;
                }
            }
            group(Source)
            {
                Caption = 'Source';
                field(DocType;DocType)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Document Type';
                    Editable = false;
                    Enabled = DocTypeEnable;
                    ToolTip = 'Specifies the type of the selected document. Leave the Document Type field blank if you want to search by posting date. The entry''s document number is shown in the Document No. field.';
                }
                field(SourceType;SourceType)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Source Type';
                    Editable = false;
                    Enabled = SourceTypeEnable;
                    ToolTip = 'Specifies the source type of the selected document or remains blank if you search by posting date. The entry''s document number is shown in the Document No. field.';
                }
                field(SourceNo;SourceNo)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Source No.';
                    Editable = false;
                    Enabled = SourceNoEnable;
                    ToolTip = 'Specifies the source number of the selected document. The entry''s document number is shown in the Document No. field.';
                }
                field(SourceName;SourceName)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Source Name';
                    Editable = false;
                    Enabled = SourceNameEnable;
                    ToolTip = 'Specifies the source name on the selected entry. The entry''s document number is shown in the Document No. field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Process)
            {
                Caption = 'Process';
                action(Show)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Show Related Entries';
                    Enabled = ShowEnable;
                    Image = ViewDocumentLine;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunPageMode = View;
                    ToolTip = 'Show the related entries of the type that you have chosen.';

                    trigger OnAction()
                    begin
                        ShowRecords;
                    end;
                }
                action(Find)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Fi&nd';
                    Image = Find;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Apply a filter to search on this page.';

                    trigger OnAction()
                    begin
                        FindPush;
                        FilterSelectionChangedTxtVisible := false;
                    end;
                }
                action(Print)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Print';
                    Ellipsis = true;
                    Enabled = PrintEnable;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';

                    trigger OnAction()
                    var
                        ItemTrackingNavigate: Report "Item Tracking Navigate";
                        DocumentEntries: Report "Document Entries";
                    begin
                        if ItemTrackingSearch then begin
                          Clear(ItemTrackingNavigate);
                          ItemTrackingNavigate.TransferDocEntries(Rec);
                          ItemTrackingNavigate.TransferRecordBuffer(TempRecordBuffer);
                          ItemTrackingNavigate.TransferFilters(SerialNoFilter,LotNoFilter,'','');
                          ItemTrackingNavigate.Run;
                        end else begin
                          DocumentEntries.TransferDocEntries(Rec);
                          DocumentEntries.TransferFilters(DocNoFilter,PostingDateFilter);
                          if NavigateDeposit then
                            DocumentEntries.SetExternal;
                          DocumentEntries.Run;
                        end;
                    end;
                }
            }
            group(FindGroup)
            {
                Caption = 'Find by';
                action(FindByDocument)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Find by Document';
                    Image = Documents;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'View entries based on the specified document number.';

                    trigger OnAction()
                    begin
                        FindBasedOn := Findbasedon::Document;
                        UpdateFindByGroupsVisibility;
                    end;
                }
                action(FindByBusinessContact)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Find by Business Contact';
                    Image = ContactPerson;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Filter entries based on the specified contact or contact type.';

                    trigger OnAction()
                    begin
                        FindBasedOn := Findbasedon::"Business Contact";
                        UpdateFindByGroupsVisibility;
                    end;
                }
                action(FindByItemReference)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Find by Item Reference';
                    Image = ItemTracking;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Filter entries based on the specified serial number or lot number.';

                    trigger OnAction()
                    begin
                        FindBasedOn := Findbasedon::"Item Reference";
                        UpdateFindByGroupsVisibility;
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        SourceNameEnable := true;
        SourceNoEnable := true;
        SourceTypeEnable := true;
        DocTypeEnable := true;
        PrintEnable := true;
        ShowEnable := true;
        DocumentVisible := true;
        FindBasedOn := Findbasedon::Document;
    end;

    trigger OnOpenPage()
    begin
        UpdateForm := true;
        FindRecordsOnOpen;
    end;

    var
        Text000: label 'The business contact type was not specified.';
        Text001: label 'There are no posted records with this external document number.';
        Text002: label 'Counting records...';
        Text003: label 'Posted Sales Invoice';
        Text004: label 'Posted Sales Credit Memo';
        Text005: label 'Posted Sales Shipment';
        Text006: label 'Issued Reminder';
        Text007: label 'Issued Finance Charge Memo';
        Text008: label 'Posted Purchase Invoice';
        Text009: label 'Posted Purchase Credit Memo';
        Text010: label 'Posted Purchase Receipt';
        Text011: label 'The document number has been used more than once.';
        Text012: label 'This combination of document number and posting date has been used more than once.';
        Text013: label 'There are no posted records with this document number.';
        Text014: label 'There are no posted records with this combination of document number and posting date.';
        Text015: label 'The search results in too many external documents. Specify a business contact no.';
        Text016: label 'The search results in too many external documents. Use Navigate from the relevant ledger entries.';
        Text017: label 'Posted Return Receipt';
        Text018: label 'Posted Return Shipment';
        Text019: label 'Posted Transfer Shipment';
        Text020: label 'Posted Transfer Receipt';
        Text021: label 'Sales Order';
        Text022: label 'Sales Invoice';
        Text023: label 'Sales Return Order';
        Text024: label 'Sales Credit Memo';
        Text025: label 'Posted Assembly Order';
        sText003: label 'Posted Service Invoice';
        sText004: label 'Posted Service Credit Memo';
        sText005: label 'Posted Service Shipment';
        sText021: label 'Service Order';
        sText022: label 'Service Invoice';
        sText024: label 'Service Credit Memo';
        Text99000000: label 'Production Order';
        [SecurityFiltering(Securityfilter::Filtered)]Cust: Record Customer;
        [SecurityFiltering(Securityfilter::Filtered)]Vend: Record Vendor;
        [SecurityFiltering(Securityfilter::Filtered)]Bank: Record "Bank Account";
        SOSalesHeader: Record "Sales Header";
        SISalesHeader: Record "Sales Header";
        SROSalesHeader: Record "Sales Header";
        SCMSalesHeader: Record "Sales Header";
        [SecurityFiltering(Securityfilter::Filtered)]SalesShptHeader: Record "Sales Shipment Header";
        [SecurityFiltering(Securityfilter::Filtered)]SalesInvHeader: Record "Sales Invoice Header";
        [SecurityFiltering(Securityfilter::Filtered)]ReturnRcptHeader: Record "Return Receipt Header";
        [SecurityFiltering(Securityfilter::Filtered)]SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SOServHeader: Record "Service Header";
        SIServHeader: Record "Service Header";
        SCMServHeader: Record "Service Header";
        [SecurityFiltering(Securityfilter::Filtered)]ServShptHeader: Record "Service Shipment Header";
        [SecurityFiltering(Securityfilter::Filtered)]ServInvHeader: Record "Service Invoice Header";
        [SecurityFiltering(Securityfilter::Filtered)]ServCrMemoHeader: Record "Service Cr.Memo Header";
        [SecurityFiltering(Securityfilter::Filtered)]IssuedReminderHeader: Record "Issued Reminder Header";
        [SecurityFiltering(Securityfilter::Filtered)]IssuedFinChrgMemoHeader: Record "Issued Fin. Charge Memo Header";
        [SecurityFiltering(Securityfilter::Filtered)]PurchRcptHeader: Record "Purch. Rcpt. Header";
        [SecurityFiltering(Securityfilter::Filtered)]PurchInvHeader: Record "Purch. Inv. Header";
        [SecurityFiltering(Securityfilter::Filtered)]ReturnShptHeader: Record "Return Shipment Header";
        [SecurityFiltering(Securityfilter::Filtered)]PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        [SecurityFiltering(Securityfilter::Filtered)]ProductionOrderHeader: Record "Production Order";
        [SecurityFiltering(Securityfilter::Filtered)]PostedAssemblyHeader: Record "Posted Assembly Header";
        [SecurityFiltering(Securityfilter::Filtered)]TransShptHeader: Record "Transfer Shipment Header";
        [SecurityFiltering(Securityfilter::Filtered)]TransRcptHeader: Record "Transfer Receipt Header";
        [SecurityFiltering(Securityfilter::Filtered)]PostedWhseRcptLine: Record "Posted Whse. Receipt Line";
        [SecurityFiltering(Securityfilter::Filtered)]PostedWhseShptLine: Record "Posted Whse. Shipment Line";
        [SecurityFiltering(Securityfilter::Filtered)]GLEntry: Record "G/L Entry";
        [SecurityFiltering(Securityfilter::Filtered)]VATEntry: Record "VAT Entry";
        [SecurityFiltering(Securityfilter::Filtered)]CustLedgEntry: Record "Cust. Ledger Entry";
        [SecurityFiltering(Securityfilter::Filtered)]DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        [SecurityFiltering(Securityfilter::Filtered)]VendLedgEntry: Record "Vendor Ledger Entry";
        [SecurityFiltering(Securityfilter::Filtered)]DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        [SecurityFiltering(Securityfilter::Filtered)]ItemLedgEntry: Record "Item Ledger Entry";
        [SecurityFiltering(Securityfilter::Filtered)]PhysInvtLedgEntry: Record "Phys. Inventory Ledger Entry";
        [SecurityFiltering(Securityfilter::Filtered)]ResLedgEntry: Record "Res. Ledger Entry";
        [SecurityFiltering(Securityfilter::Filtered)]JobLedgEntry: Record "Job Ledger Entry";
        [SecurityFiltering(Securityfilter::Filtered)]JobWIPEntry: Record "Job WIP Entry";
        [SecurityFiltering(Securityfilter::Filtered)]JobWIPGLEntry: Record "Job WIP G/L Entry";
        [SecurityFiltering(Securityfilter::Filtered)]ValueEntry: Record "Value Entry";
        [SecurityFiltering(Securityfilter::Filtered)]BankAccLedgEntry: Record "Bank Account Ledger Entry";
        [SecurityFiltering(Securityfilter::Filtered)]CheckLedgEntry: Record "Check Ledger Entry";
        [SecurityFiltering(Securityfilter::Filtered)]ReminderEntry: Record "Reminder/Fin. Charge Entry";
        [SecurityFiltering(Securityfilter::Filtered)]FALedgEntry: Record "FA Ledger Entry";
        [SecurityFiltering(Securityfilter::Filtered)]MaintenanceLedgEntry: Record "Maintenance Ledger Entry";
        [SecurityFiltering(Securityfilter::Filtered)]InsuranceCovLedgEntry: Record "Ins. Coverage Ledger Entry";
        [SecurityFiltering(Securityfilter::Filtered)]CapacityLedgEntry: Record "Capacity Ledger Entry";
        [SecurityFiltering(Securityfilter::Filtered)]ServLedgerEntry: Record "Service Ledger Entry";
        [SecurityFiltering(Securityfilter::Filtered)]WarrantyLedgerEntry: Record "Warranty Ledger Entry";
        [SecurityFiltering(Securityfilter::Filtered)]WhseEntry: Record "Warehouse Entry";
        TempRecordBuffer: Record "Record Buffer" temporary;
        [SecurityFiltering(Securityfilter::Filtered)]CostEntry: Record "Cost Entry";
        [SecurityFiltering(Securityfilter::Filtered)]PostedDepositHeader: Record UnknownRecord10143;
        [SecurityFiltering(Securityfilter::Filtered)]PostedDepositLine: Record UnknownRecord10144;
        [SecurityFiltering(Securityfilter::Filtered)]IncomingDocument: Record "Incoming Document";
        ApplicationManagement: Codeunit ApplicationManagement;
        ItemTrackingNavigateMgt: Codeunit "Item Tracking Navigate Mgt.";
        Window: Dialog;
        DocNoFilter: Text;
        PostingDateFilter: Text;
        NewDocNo: Code[20];
        ContactNo: Code[250];
        ExtDocNo: Code[250];
        NewPostingDate: Date;
        DocType: Text[50];
        SourceType: Text[30];
        SourceNo: Code[20];
        SourceName: Text[50];
        ContactType: Option " ",Vendor,Customer,"Bank Account";
        DocExists: Boolean;
        NavigateDeposit: Boolean;
        USText001: label 'Before you can navigate on a deposit, you must create and activate a key group called "NavDep". If you cannot do this yourself, ask your system administrator.';
        NewSerialNo: Code[20];
        NewLotNo: Code[20];
        SerialNoFilter: Text;
        LotNoFilter: Text;
        [InDataSet]
        ShowEnable: Boolean;
        [InDataSet]
        PrintEnable: Boolean;
        [InDataSet]
        DocTypeEnable: Boolean;
        [InDataSet]
        SourceTypeEnable: Boolean;
        [InDataSet]
        SourceNoEnable: Boolean;
        [InDataSet]
        SourceNameEnable: Boolean;
        UpdateForm: Boolean;
        FindBasedOn: Option Document,"Business Contact","Item Reference";
        [InDataSet]
        DocumentVisible: Boolean;
        [InDataSet]
        BusinessContactVisible: Boolean;
        [InDataSet]
        ItemReferenceVisible: Boolean;
        [InDataSet]
        FilterSelectionChangedTxtVisible: Boolean;
        PageCaptionTxt: label 'Selected - %1';


    procedure SetDoc(PostingDate: Date;DocNo: Code[20])
    begin
        NewDocNo := DocNo;
        NewPostingDate := PostingDate;
    end;

    local procedure FindExtRecords()
    var
        [SecurityFiltering(Securityfilter::Filtered)]VendLedgEntry2: Record "Vendor Ledger Entry";
        FoundRecords: Boolean;
        DateFilter2: Text;
        DocNoFilter2: Text;
    begin
        FoundRecords := false;
        case ContactType of
          Contacttype::Vendor:
            begin
              VendLedgEntry2.SetCurrentkey("External Document No.");
              VendLedgEntry2.SetFilter("External Document No.",ExtDocNo);
              VendLedgEntry2.SetFilter("Vendor No.",ContactNo);
              if VendLedgEntry2.FindSet then begin
                repeat
                  MakeExtFilter(
                    DateFilter2,
                    VendLedgEntry2."Posting Date",
                    DocNoFilter2,
                    VendLedgEntry2."Document No.");
                until VendLedgEntry2.Next = 0;
                SetPostingDate(DateFilter2);
                SetDocNo(DocNoFilter2);
                FindRecords;
                FoundRecords := true;
              end;
            end;
          Contacttype::Customer:
            begin
              DeleteAll;
              "Entry No." := 0;
              FindUnpostedSalesDocs(SOSalesHeader."document type"::Order,Text021,SOSalesHeader);
              FindUnpostedSalesDocs(SISalesHeader."document type"::Invoice,Text022,SISalesHeader);
              FindUnpostedSalesDocs(SROSalesHeader."document type"::"Return Order",Text023,SROSalesHeader);
              FindUnpostedSalesDocs(SCMSalesHeader."document type"::"Credit Memo",Text024,SCMSalesHeader);
              if SalesShptHeader.ReadPermission then begin
                SalesShptHeader.Reset;
                SalesShptHeader.SetCurrentkey("Sell-to Customer No.","External Document No.");
                SalesShptHeader.SetFilter("Sell-to Customer No.",ContactNo);
                SalesShptHeader.SetFilter("External Document No.",ExtDocNo);
                InsertIntoDocEntry(
                  Database::"Sales Shipment Header",0,Text005,SalesShptHeader.Count);
              end;
              if SalesInvHeader.ReadPermission then begin
                SalesInvHeader.Reset;
                SalesInvHeader.SetCurrentkey("Sell-to Customer No.","External Document No.");
                SalesInvHeader.SetFilter("Sell-to Customer No.",ContactNo);
                SalesInvHeader.SetFilter("External Document No.",ExtDocNo);
                InsertIntoDocEntry(
                  Database::"Sales Invoice Header",0,Text003,SalesInvHeader.Count);
              end;
              if ReturnRcptHeader.ReadPermission then begin
                ReturnRcptHeader.Reset;
                ReturnRcptHeader.SetCurrentkey("Sell-to Customer No.","External Document No.");
                ReturnRcptHeader.SetFilter("Sell-to Customer No.",ContactNo);
                ReturnRcptHeader.SetFilter("External Document No.",ExtDocNo);
                InsertIntoDocEntry(
                  Database::"Return Receipt Header",0,Text017,ReturnRcptHeader.Count);
              end;
              if SalesCrMemoHeader.ReadPermission then begin
                SalesCrMemoHeader.Reset;
                SalesCrMemoHeader.SetCurrentkey("Sell-to Customer No.","External Document No.");
                SalesCrMemoHeader.SetFilter("Sell-to Customer No.",ContactNo);
                SalesCrMemoHeader.SetFilter("External Document No.",ExtDocNo);
                InsertIntoDocEntry(
                  Database::"Sales Cr.Memo Header",0,Text004,SalesCrMemoHeader.Count);
              end;
              FindUnpostedServDocs(SOServHeader."document type"::Order,sText021,SOServHeader);
              FindUnpostedServDocs(SIServHeader."document type"::Invoice,sText022,SIServHeader);
              FindUnpostedServDocs(SCMServHeader."document type"::"Credit Memo",sText024,SCMServHeader);
              if ServShptHeader.ReadPermission then
                if ExtDocNo = '' then begin
                  ServShptHeader.Reset;
                  ServShptHeader.SetCurrentkey("Customer No.");
                  ServShptHeader.SetFilter("Customer No.",ContactNo);
                  InsertIntoDocEntry(
                    Database::"Service Shipment Header",0,sText005,ServShptHeader.Count);
                end;
              if ServInvHeader.ReadPermission then
                if ExtDocNo = '' then begin
                  ServInvHeader.Reset;
                  ServInvHeader.SetCurrentkey("Customer No.");
                  ServInvHeader.SetFilter("Customer No.",ContactNo);
                  InsertIntoDocEntry(
                    Database::"Service Invoice Header",0,sText003,ServInvHeader.Count);
                end;
              if ServCrMemoHeader.ReadPermission then
                if ExtDocNo = '' then begin
                  ServCrMemoHeader.Reset;
                  ServCrMemoHeader.SetCurrentkey("Customer No.");
                  ServCrMemoHeader.SetFilter("Customer No.",ContactNo);
                  InsertIntoDocEntry(
                    Database::"Service Cr.Memo Header",0,sText004,ServCrMemoHeader.Count);
                end;

              DocExists := FindFirst;

              UpdateFormAfterFindRecords;
              FoundRecords := DocExists;
            end;
          else
            Error(Text000);
        end;

        if not FoundRecords then begin
          SetSource(0D,'','',0,'');
          Message(Text001);
        end;
    end;

    local procedure FindRecords()
    begin
        Window.Open(Text002);
        Reset;
        DeleteAll;
        "Entry No." := 0;
        FindIncomingDocumentRecords;
        if SalesShptHeader.ReadPermission then begin
          SalesShptHeader.Reset;
          SalesShptHeader.SetFilter("No.",DocNoFilter);
          SalesShptHeader.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Sales Shipment Header",0,Text005,SalesShptHeader.Count);
        end;
        if SalesInvHeader.ReadPermission then begin
          SalesInvHeader.Reset;
          SalesInvHeader.SetFilter("No.",DocNoFilter);
          SalesInvHeader.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Sales Invoice Header",0,Text003,SalesInvHeader.Count);
        end;
        if ReturnRcptHeader.ReadPermission then begin
          ReturnRcptHeader.Reset;
          ReturnRcptHeader.SetFilter("No.",DocNoFilter);
          ReturnRcptHeader.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Return Receipt Header",0,Text017,ReturnRcptHeader.Count);
        end;
        if SalesCrMemoHeader.ReadPermission then begin
          SalesCrMemoHeader.Reset;
          SalesCrMemoHeader.SetFilter("No.",DocNoFilter);
          SalesCrMemoHeader.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Sales Cr.Memo Header",0,Text004,SalesCrMemoHeader.Count);
        end;
        if ServShptHeader.ReadPermission then begin
          ServShptHeader.Reset;
          ServShptHeader.SetFilter("No.",DocNoFilter);
          ServShptHeader.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Service Shipment Header",0,sText005,ServShptHeader.Count);
        end;
        if ServInvHeader.ReadPermission then begin
          ServInvHeader.Reset;
          ServInvHeader.SetFilter("No.",DocNoFilter);
          ServInvHeader.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Service Invoice Header",0,sText003,ServInvHeader.Count);
        end;
        if ServCrMemoHeader.ReadPermission then begin
          ServCrMemoHeader.Reset;
          ServCrMemoHeader.SetFilter("No.",DocNoFilter);
          ServCrMemoHeader.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Service Cr.Memo Header",0,sText004,ServCrMemoHeader.Count);
        end;
        if IssuedReminderHeader.ReadPermission then begin
          IssuedReminderHeader.Reset;
          IssuedReminderHeader.SetFilter("No.",DocNoFilter);
          IssuedReminderHeader.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Issued Reminder Header",0,Text006,IssuedReminderHeader.Count);
        end;
        if IssuedFinChrgMemoHeader.ReadPermission then begin
          IssuedFinChrgMemoHeader.Reset;
          IssuedFinChrgMemoHeader.SetFilter("No.",DocNoFilter);
          IssuedFinChrgMemoHeader.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Issued Fin. Charge Memo Header",0,Text007,
            IssuedFinChrgMemoHeader.Count);
        end;
        if PurchRcptHeader.ReadPermission then begin
          PurchRcptHeader.Reset;
          PurchRcptHeader.SetFilter("No.",DocNoFilter);
          PurchRcptHeader.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Purch. Rcpt. Header",0,Text010,PurchRcptHeader.Count);
        end;
        if PurchInvHeader.ReadPermission then begin
          PurchInvHeader.Reset;
          PurchInvHeader.SetFilter("No.",DocNoFilter);
          PurchInvHeader.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Purch. Inv. Header",0,Text008,PurchInvHeader.Count);
        end;
        if ReturnShptHeader.ReadPermission then begin
          ReturnShptHeader.Reset;
          ReturnShptHeader.SetFilter("No.",DocNoFilter);
          ReturnShptHeader.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Return Shipment Header",0,Text018,ReturnShptHeader.Count);
        end;
        if PurchCrMemoHeader.ReadPermission then begin
          PurchCrMemoHeader.Reset;
          PurchCrMemoHeader.SetFilter("No.",DocNoFilter);
          PurchCrMemoHeader.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Purch. Cr. Memo Hdr.",0,Text009,PurchCrMemoHeader.Count);
        end;
        if ProductionOrderHeader.ReadPermission then begin
          ProductionOrderHeader.Reset;
          ProductionOrderHeader.SetRange(
            Status,
            ProductionOrderHeader.Status::Released,
            ProductionOrderHeader.Status::Finished);
          ProductionOrderHeader.SetFilter("No.",DocNoFilter);
          InsertIntoDocEntry(
            Database::"Production Order",0,Text99000000,ProductionOrderHeader.Count);
        end;
        if PostedAssemblyHeader.ReadPermission then begin
          PostedAssemblyHeader.Reset;
          PostedAssemblyHeader.SetFilter("No.",DocNoFilter);
          InsertIntoDocEntry(
            Database::"Posted Assembly Header",0,Text025,PostedAssemblyHeader.Count);
        end;
        if TransShptHeader.ReadPermission then begin
          TransShptHeader.Reset;
          TransShptHeader.SetFilter("No.",DocNoFilter);
          TransShptHeader.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Transfer Shipment Header",0,Text019,TransShptHeader.Count);
        end;
        if TransRcptHeader.ReadPermission then begin
          TransRcptHeader.Reset;
          TransRcptHeader.SetFilter("No.",DocNoFilter);
          TransRcptHeader.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Transfer Receipt Header",0,Text020,TransRcptHeader.Count);
        end;
        if PostedWhseShptLine.ReadPermission then begin
          PostedWhseShptLine.Reset;
          PostedWhseShptLine.SetCurrentkey("Posted Source No.","Posting Date");
          PostedWhseShptLine.SetFilter("Posted Source No.",DocNoFilter);
          PostedWhseShptLine.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Posted Whse. Shipment Line",0,
            PostedWhseShptLine.TableCaption,PostedWhseShptLine.Count);
        end;
        if PostedWhseRcptLine.ReadPermission then begin
          PostedWhseRcptLine.Reset;
          PostedWhseRcptLine.SetCurrentkey("Posted Source No.","Posting Date");
          PostedWhseRcptLine.SetFilter("Posted Source No.",DocNoFilter);
          PostedWhseRcptLine.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Posted Whse. Receipt Line",0,
            PostedWhseRcptLine.TableCaption,PostedWhseRcptLine.Count);
        end;
        if GLEntry.ReadPermission then begin
          GLEntry.Reset;
          GLEntry.SetCurrentkey("Document No.","Posting Date");
          GLEntry.SetFilter("Document No.",DocNoFilter);
          GLEntry.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"G/L Entry",0,GLEntry.TableCaption,GLEntry.Count);
        end;
        if VATEntry.ReadPermission then begin
          VATEntry.Reset;
          VATEntry.SetCurrentkey("Document No.","Posting Date");
          VATEntry.SetFilter("Document No.",DocNoFilter);
          VATEntry.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"VAT Entry",0,VATEntry.TableCaption,VATEntry.Count);
        end;
        if CustLedgEntry.ReadPermission then begin
          CustLedgEntry.Reset;
          CustLedgEntry.SetCurrentkey("Document No.");
          CustLedgEntry.SetFilter("Document No.",DocNoFilter);
          CustLedgEntry.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Cust. Ledger Entry",0,CustLedgEntry.TableCaption,CustLedgEntry.Count);
        end;
        if DtldCustLedgEntry.ReadPermission then begin
          DtldCustLedgEntry.Reset;
          DtldCustLedgEntry.SetCurrentkey("Document No.");
          DtldCustLedgEntry.SetFilter("Document No.",DocNoFilter);
          DtldCustLedgEntry.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Detailed Cust. Ledg. Entry",0,DtldCustLedgEntry.TableCaption,DtldCustLedgEntry.Count);
        end;
        if ReminderEntry.ReadPermission then begin
          ReminderEntry.Reset;
          ReminderEntry.SetCurrentkey(Type,"No.");
          ReminderEntry.SetFilter("No.",DocNoFilter);
          ReminderEntry.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Reminder/Fin. Charge Entry",0,ReminderEntry.TableCaption,ReminderEntry.Count);
        end;
        if VendLedgEntry.ReadPermission then begin
          VendLedgEntry.Reset;
          VendLedgEntry.SetCurrentkey("Document No.");
          VendLedgEntry.SetFilter("Document No.",DocNoFilter);
          VendLedgEntry.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Vendor Ledger Entry",0,VendLedgEntry.TableCaption,VendLedgEntry.Count);
        end;
        if DtldVendLedgEntry.ReadPermission then begin
          DtldVendLedgEntry.Reset;
          DtldVendLedgEntry.SetCurrentkey("Document No.");
          DtldVendLedgEntry.SetFilter("Document No.",DocNoFilter);
          DtldVendLedgEntry.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Detailed Vendor Ledg. Entry",0,DtldVendLedgEntry.TableCaption,DtldVendLedgEntry.Count);
        end;
        if ItemLedgEntry.ReadPermission then begin
          ItemLedgEntry.Reset;
          ItemLedgEntry.SetCurrentkey("Document No.");
          ItemLedgEntry.SetFilter("Document No.",DocNoFilter);
          ItemLedgEntry.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Item Ledger Entry",0,ItemLedgEntry.TableCaption,ItemLedgEntry.Count);
        end;
        if ValueEntry.ReadPermission then begin
          ValueEntry.Reset;
          ValueEntry.SetCurrentkey("Document No.");
          ValueEntry.SetFilter("Document No.",DocNoFilter);
          ValueEntry.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Value Entry",0,ValueEntry.TableCaption,ValueEntry.Count);
        end;
        if PhysInvtLedgEntry.ReadPermission then begin
          PhysInvtLedgEntry.Reset;
          PhysInvtLedgEntry.SetCurrentkey("Document No.","Posting Date");
          PhysInvtLedgEntry.SetFilter("Document No.",DocNoFilter);
          PhysInvtLedgEntry.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Phys. Inventory Ledger Entry",0,PhysInvtLedgEntry.TableCaption,PhysInvtLedgEntry.Count);
        end;
        if ResLedgEntry.ReadPermission then begin
          ResLedgEntry.Reset;
          ResLedgEntry.SetCurrentkey("Document No.","Posting Date");
          ResLedgEntry.SetFilter("Document No.",DocNoFilter);
          ResLedgEntry.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Res. Ledger Entry",0,ResLedgEntry.TableCaption,ResLedgEntry.Count);
        end;
        FindJobRecords;
        if BankAccLedgEntry.ReadPermission then begin
          BankAccLedgEntry.Reset;
          BankAccLedgEntry.SetCurrentkey("Document No.","Posting Date");
          BankAccLedgEntry.SetFilter("Document No.",DocNoFilter);
          BankAccLedgEntry.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Bank Account Ledger Entry",0,BankAccLedgEntry.TableCaption,BankAccLedgEntry.Count);
        end;
        if CheckLedgEntry.ReadPermission then begin
          CheckLedgEntry.Reset;
          CheckLedgEntry.SetCurrentkey("Document No.","Posting Date");
          CheckLedgEntry.SetFilter("Document No.",DocNoFilter);
          CheckLedgEntry.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Check Ledger Entry",0,CheckLedgEntry.TableCaption,CheckLedgEntry.Count);
        end;
        if FALedgEntry.ReadPermission then begin
          FALedgEntry.Reset;
          FALedgEntry.SetCurrentkey("Document No.","Posting Date");
          FALedgEntry.SetFilter("Document No.",DocNoFilter);
          FALedgEntry.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"FA Ledger Entry",0,FALedgEntry.TableCaption,FALedgEntry.Count);
        end;
        if MaintenanceLedgEntry.ReadPermission then begin
          MaintenanceLedgEntry.Reset;
          MaintenanceLedgEntry.SetCurrentkey("Document No.","Posting Date");
          MaintenanceLedgEntry.SetFilter("Document No.",DocNoFilter);
          MaintenanceLedgEntry.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Maintenance Ledger Entry",0,MaintenanceLedgEntry.TableCaption,MaintenanceLedgEntry.Count);
        end;
        if InsuranceCovLedgEntry.ReadPermission then begin
          InsuranceCovLedgEntry.Reset;
          InsuranceCovLedgEntry.SetCurrentkey("Document No.","Posting Date");
          InsuranceCovLedgEntry.SetFilter("Document No.",DocNoFilter);
          InsuranceCovLedgEntry.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Ins. Coverage Ledger Entry",0,InsuranceCovLedgEntry.TableCaption,InsuranceCovLedgEntry.Count);
        end;
        if CapacityLedgEntry.ReadPermission then begin
          CapacityLedgEntry.Reset;
          CapacityLedgEntry.SetCurrentkey("Document No.","Posting Date");
          CapacityLedgEntry.SetFilter("Document No.",DocNoFilter);
          CapacityLedgEntry.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Capacity Ledger Entry",0,CapacityLedgEntry.TableCaption,CapacityLedgEntry.Count);
        end;
        if WhseEntry.ReadPermission then begin
          WhseEntry.Reset;
          WhseEntry.SetCurrentkey("Reference No.","Registering Date");
          WhseEntry.SetFilter("Reference No.",DocNoFilter);
          WhseEntry.SetFilter("Registering Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Warehouse Entry",0,WhseEntry.TableCaption,WhseEntry.Count);
        end;

        if ServLedgerEntry.ReadPermission then begin
          ServLedgerEntry.Reset;
          ServLedgerEntry.SetCurrentkey("Document No.","Posting Date");
          ServLedgerEntry.SetFilter("Document No.",DocNoFilter);
          ServLedgerEntry.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Service Ledger Entry",0,ServLedgerEntry.TableCaption,ServLedgerEntry.Count);
        end;
        if WarrantyLedgerEntry.ReadPermission then begin
          WarrantyLedgerEntry.Reset;
          WarrantyLedgerEntry.SetCurrentkey("Document No.","Posting Date");
          WarrantyLedgerEntry.SetFilter("Document No.",DocNoFilter);
          WarrantyLedgerEntry.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Warranty Ledger Entry",0,WarrantyLedgerEntry.TableCaption,WarrantyLedgerEntry.Count);
        end;

        if CostEntry.ReadPermission then begin
          CostEntry.Reset;
          CostEntry.SetCurrentkey("Document No.","Posting Date");
          CostEntry.SetFilter("Document No.",DocNoFilter);
          CostEntry.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Cost Entry",0,CostEntry.TableCaption,CostEntry.Count);
        end;

        if PostedDepositHeader.ReadPermission then begin
          PostedDepositHeader.Reset;
          PostedDepositHeader.SetFilter("No.",DocNoFilter);
          InsertIntoDocEntry(
            Database::"Posted Deposit Header",0,PostedDepositHeader.TableCaption,PostedDepositHeader.Count);
        end;
        if PostedDepositLine.ReadPermission then begin
          PostedDepositLine.Reset;
          PostedDepositLine.SetCurrentkey("Document No.","Posting Date");
          PostedDepositLine.SetFilter("Document No.",DocNoFilter);
          PostedDepositLine.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Posted Deposit Line",0,PostedDepositLine.TableCaption,PostedDepositLine.Count);
        end;
        OnAfterNavigateFindRecords(Rec,DocNoFilter,PostingDateFilter);
        DocExists := FindFirst;

        SetSource(0D,'','',0,'');
        if DocExists then begin
          if (NoOfRecords(Database::"Cust. Ledger Entry") + NoOfRecords(Database::"Vendor Ledger Entry") <= 1) and
             (NoOfRecords(Database::"Sales Invoice Header") + NoOfRecords(Database::"Sales Cr.Memo Header") +
              NoOfRecords(Database::"Sales Shipment Header") + NoOfRecords(Database::"Issued Reminder Header") +
              NoOfRecords(Database::"Issued Fin. Charge Memo Header") + NoOfRecords(Database::"Purch. Inv. Header") +
              NoOfRecords(Database::"Return Shipment Header") + NoOfRecords(Database::"Return Receipt Header") +
              NoOfRecords(Database::"Purch. Cr. Memo Hdr.") + NoOfRecords(Database::"Purch. Rcpt. Header") +
              NoOfRecords(Database::"Service Invoice Header") + NoOfRecords(Database::"Service Cr.Memo Header") +
              NoOfRecords(Database::"Service Shipment Header") +
              NoOfRecords(Database::"Transfer Shipment Header") + NoOfRecords(Database::"Transfer Receipt Header") +
              NoOfRecords(Database::"Posted Deposit Header") + NoOfRecords(Database::"Posted Deposit Header") <= 1)
          then begin
            // Service Management
            if NoOfRecords(Database::"Service Ledger Entry") = 1 then begin
              ServLedgerEntry.FindFirst;
              if ServLedgerEntry.Type = ServLedgerEntry.Type::"Service Contract" then
                SetSource(
                  ServLedgerEntry."Posting Date",Format(ServLedgerEntry."Document Type"),ServLedgerEntry."Document No.",
                  2,ServLedgerEntry."Service Contract No.")
              else
                SetSource(
                  ServLedgerEntry."Posting Date",Format(ServLedgerEntry."Document Type"),ServLedgerEntry."Document No.",
                  2,ServLedgerEntry."Service Order No.")
            end;
            if NoOfRecords(Database::"Warranty Ledger Entry") = 1 then begin
              WarrantyLedgerEntry.FindFirst;
              SetSource(
                WarrantyLedgerEntry."Posting Date",'',WarrantyLedgerEntry."Document No.",
                2,WarrantyLedgerEntry."Service Order No.")
            end;

            // Sales
            if NoOfRecords(Database::"Cust. Ledger Entry") = 1 then begin
              CustLedgEntry.FindFirst;
              SetSource(
                CustLedgEntry."Posting Date",Format(CustLedgEntry."Document Type"),CustLedgEntry."Document No.",
                1,CustLedgEntry."Customer No.");
            end;
            if NoOfRecords(Database::"Detailed Cust. Ledg. Entry") = 1 then begin
              DtldCustLedgEntry.FindFirst;
              SetSource(
                DtldCustLedgEntry."Posting Date",Format(DtldCustLedgEntry."Document Type"),DtldCustLedgEntry."Document No.",
                1,DtldCustLedgEntry."Customer No.");
            end;
            if NoOfRecords(Database::"Sales Invoice Header") = 1 then begin
              SalesInvHeader.FindFirst;
              SetSource(
                SalesInvHeader."Posting Date",Format("Table Name"),SalesInvHeader."No.",
                1,SalesInvHeader."Bill-to Customer No.");
            end;
            if NoOfRecords(Database::"Sales Cr.Memo Header") = 1 then begin
              SalesCrMemoHeader.FindFirst;
              SetSource(
                SalesCrMemoHeader."Posting Date",Format("Table Name"),SalesCrMemoHeader."No.",
                1,SalesCrMemoHeader."Bill-to Customer No.");
            end;
            if NoOfRecords(Database::"Return Receipt Header") = 1 then begin
              ReturnRcptHeader.FindFirst;
              SetSource(
                ReturnRcptHeader."Posting Date",Format("Table Name"),ReturnRcptHeader."No.",
                1,ReturnRcptHeader."Sell-to Customer No.");
            end;
            if NoOfRecords(Database::"Sales Shipment Header") = 1 then begin
              SalesShptHeader.FindFirst;
              SetSource(
                SalesShptHeader."Posting Date",Format("Table Name"),SalesShptHeader."No.",
                1,SalesShptHeader."Sell-to Customer No.");
            end;
            if NoOfRecords(Database::"Posted Whse. Shipment Line") = 1 then begin
              PostedWhseShptLine.FindFirst;
              SetSource(
                PostedWhseShptLine."Posting Date",Format("Table Name"),PostedWhseShptLine."No.",
                1,PostedWhseShptLine."Destination No.");
            end;
            if NoOfRecords(Database::"Issued Reminder Header") = 1 then begin
              IssuedReminderHeader.FindFirst;
              SetSource(
                IssuedReminderHeader."Posting Date",Format("Table Name"),IssuedReminderHeader."No.",
                1,IssuedReminderHeader."Customer No.");
            end;
            if NoOfRecords(Database::"Issued Fin. Charge Memo Header") = 1 then begin
              IssuedFinChrgMemoHeader.FindFirst;
              SetSource(
                IssuedFinChrgMemoHeader."Posting Date",Format("Table Name"),IssuedFinChrgMemoHeader."No.",
                1,IssuedFinChrgMemoHeader."Customer No.");
            end;

            if NoOfRecords(Database::"Service Invoice Header") = 1 then begin
              ServInvHeader.FindFirst;
              SetSource(
                ServInvHeader."Posting Date",Format("Table Name"),ServInvHeader."No.",
                1,ServInvHeader."Bill-to Customer No.");
            end;
            if NoOfRecords(Database::"Service Cr.Memo Header") = 1 then begin
              ServCrMemoHeader.FindFirst;
              SetSource(
                ServCrMemoHeader."Posting Date",Format("Table Name"),ServCrMemoHeader."No.",
                1,ServCrMemoHeader."Bill-to Customer No.");
            end;
            if NoOfRecords(Database::"Service Shipment Header") = 1 then begin
              ServShptHeader.FindFirst;
              SetSource(
                ServShptHeader."Posting Date",Format("Table Name"),ServShptHeader."No.",
                1,ServShptHeader."Customer No.");
            end;

            // Purchase
            if NoOfRecords(Database::"Vendor Ledger Entry") = 1 then begin
              VendLedgEntry.FindFirst;
              SetSource(
                VendLedgEntry."Posting Date",Format(VendLedgEntry."Document Type"),VendLedgEntry."Document No.",
                2,VendLedgEntry."Vendor No.");
            end;
            if NoOfRecords(Database::"Detailed Vendor Ledg. Entry") = 1 then begin
              DtldVendLedgEntry.FindFirst;
              SetSource(
                DtldVendLedgEntry."Posting Date",Format(DtldVendLedgEntry."Document Type"),DtldVendLedgEntry."Document No.",
                2,DtldVendLedgEntry."Vendor No.");
            end;
            if NoOfRecords(Database::"Purch. Inv. Header") = 1 then begin
              PurchInvHeader.FindFirst;
              SetSource(
                PurchInvHeader."Posting Date",Format("Table Name"),PurchInvHeader."No.",
                2,PurchInvHeader."Pay-to Vendor No.");
            end;
            if NoOfRecords(Database::"Purch. Cr. Memo Hdr.") = 1 then begin
              PurchCrMemoHeader.FindFirst;
              SetSource(
                PurchCrMemoHeader."Posting Date",Format("Table Name"),PurchCrMemoHeader."No.",
                2,PurchCrMemoHeader."Pay-to Vendor No.");
            end;
            if NoOfRecords(Database::"Return Shipment Header") = 1 then begin
              ReturnShptHeader.FindFirst;
              SetSource(
                ReturnShptHeader."Posting Date",Format("Table Name"),ReturnShptHeader."No.",
                2,ReturnShptHeader."Buy-from Vendor No.");
            end;
            if NoOfRecords(Database::"Purch. Rcpt. Header") = 1 then begin
              PurchRcptHeader.FindFirst;
              SetSource(
                PurchRcptHeader."Posting Date",Format("Table Name"),PurchRcptHeader."No.",
                2,PurchRcptHeader."Buy-from Vendor No.");
            end;
            if NoOfRecords(Database::"Posted Whse. Receipt Line") = 1 then begin
              PostedWhseRcptLine.FindFirst;
              SetSource(
                PostedWhseRcptLine."Posting Date",Format("Table Name"),PostedWhseRcptLine."No.",
                2,'');
            end;
            if NoOfRecords(Database::"Posted Deposit Header") = 1 then begin
              PostedDepositHeader.FindFirst;
              SetSource(
                PostedDepositHeader."Posting Date",Format("Table Name"),PostedDepositHeader."No.",
                4,PostedDepositHeader."Bank Account No.");
            end;
          end else begin
            if DocNoFilter <> '' then
              if PostingDateFilter = '' then
                Message(Text011)
              else
                Message(Text012);
          end;
        end else
          if PostingDateFilter = '' then
            Message(Text013)
          else
            Message(Text014);

        if UpdateForm then
          UpdateFormAfterFindRecords;
        Window.Close;
    end;

    local procedure FindJobRecords()
    begin
        if JobLedgEntry.ReadPermission then begin
          JobLedgEntry.Reset;
          JobLedgEntry.SetCurrentkey("Document No.","Posting Date");
          JobLedgEntry.SetFilter("Document No.",DocNoFilter);
          JobLedgEntry.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Job Ledger Entry",0,JobLedgEntry.TableCaption,JobLedgEntry.Count);
        end;
        if JobWIPEntry.ReadPermission then begin
          JobWIPEntry.Reset;
          JobWIPEntry.SetFilter("Document No.",DocNoFilter);
          JobWIPEntry.SetFilter("WIP Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Job WIP Entry",0,JobWIPEntry.TableCaption,JobWIPEntry.Count);
        end;
        if JobWIPGLEntry.ReadPermission then begin
          JobWIPGLEntry.Reset;
          JobWIPGLEntry.SetCurrentkey("Document No.","Posting Date");
          JobWIPGLEntry.SetFilter("Document No.",DocNoFilter);
          JobWIPGLEntry.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Job WIP G/L Entry",0,JobWIPGLEntry.TableCaption,JobWIPGLEntry.Count);
        end;
    end;

    local procedure FindIncomingDocumentRecords()
    begin
        if IncomingDocument.ReadPermission then begin
          IncomingDocument.Reset;
          IncomingDocument.SetFilter("Document No.",DocNoFilter);
          IncomingDocument.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Incoming Document",0,IncomingDocument.TableCaption,IncomingDocument.Count);
        end;
    end;

    local procedure UpdateFormAfterFindRecords()
    begin
        ShowEnable := DocExists;
        PrintEnable := DocExists;
        CurrPage.Update(false);
        DocExists := FindFirst;
        if DocExists then;
    end;

    local procedure InsertIntoDocEntry(DocTableID: Integer;DocType: Option;DocTableName: Text[1024];DocNoOfRecords: Integer)
    begin
        if DocNoOfRecords = 0 then
          exit;
        Init;
        "Entry No." := "Entry No." + 1;
        "Table ID" := DocTableID;
        "Document Type" := DocType;
        "Table Name" := CopyStr(DocTableName,1,MaxStrLen("Table Name"));
        "No. of Records" := DocNoOfRecords;
        Insert;
    end;

    local procedure NoOfRecords(TableID: Integer): Integer
    begin
        SetRange("Table ID",TableID);
        if not FindFirst then
          Init;
        SetRange("Table ID");
        exit("No. of Records");
    end;

    local procedure SetSource(PostingDate: Date;DocType2: Text[50];DocNo: Text[50];SourceType2: Integer;SourceNo2: Code[20])
    begin
        if SourceType2 = 0 then begin
          DocType := '';
          SourceType := '';
          SourceNo := '';
          SourceName := '';
        end else begin
          DocType := DocType2;
          SourceNo := SourceNo2;
          SetRange("Document No.",DocNo);
          SetRange("Posting Date",PostingDate);
          DocNoFilter := GetFilter("Document No.");
          PostingDateFilter := GetFilter("Posting Date");
          case SourceType2 of
            1:
              begin
                SourceType := Cust.TableCaption;
                if not Cust.Get(SourceNo) then
                  Cust.Init;
                SourceName := Cust.Name;
              end;
            2:
              begin
                SourceType := Vend.TableCaption;
                if not Vend.Get(SourceNo) then
                  Vend.Init;
                SourceName := Vend.Name;
              end;
            4:
              begin
                SourceType := Bank.TableCaption;
                if not Bank.Get(SourceNo) then
                  Bank.Init;
                SourceName := Bank.Name;
              end;
          end;
        end;
        DocTypeEnable := SourceType2 <> 0;
        SourceTypeEnable := SourceType2 <> 0;
        SourceNoEnable := SourceType2 <> 0;
        SourceNameEnable := SourceType2 <> 0;
    end;

    local procedure ShowRecords()
    begin
        if ItemTrackingSearch then
          ItemTrackingNavigateMgt.Show("Table ID")
        else
          case "Table ID" of
            Database::"Incoming Document":
              Page.Run(Page::"Incoming Document",IncomingDocument);
            Database::"Sales Header":
              ShowSalesHeaderRecords;
            Database::"Sales Invoice Header":
              if "No. of Records" = 1 then
                Page.Run(Page::"Posted Sales Invoice",SalesInvHeader)
              else
                Page.Run(Page::"Posted Sales Invoices",SalesInvHeader);
            Database::"Sales Cr.Memo Header":
              if "No. of Records" = 1 then
                Page.Run(Page::"Posted Sales Credit Memo",SalesCrMemoHeader)
              else
                Page.Run(Page::"Posted Sales Credit Memos",SalesCrMemoHeader);
            Database::"Return Receipt Header":
              if "No. of Records" = 1 then
                Page.Run(Page::"Posted Return Receipt",ReturnRcptHeader)
              else
                Page.Run(0,ReturnRcptHeader);
            Database::"Sales Shipment Header":
              if "No. of Records" = 1 then
                Page.Run(Page::"Posted Sales Shipment",SalesShptHeader)
              else
                Page.Run(0,SalesShptHeader);
            Database::"Issued Reminder Header":
              if "No. of Records" = 1 then
                Page.Run(Page::"Issued Reminder",IssuedReminderHeader)
              else
                Page.Run(0,IssuedReminderHeader);
            Database::"Issued Fin. Charge Memo Header":
              if "No. of Records" = 1 then
                Page.Run(Page::"Issued Finance Charge Memo",IssuedFinChrgMemoHeader)
              else
                Page.Run(0,IssuedFinChrgMemoHeader);
            Database::"Purch. Inv. Header":
              if "No. of Records" = 1 then
                Page.Run(Page::"Posted Purchase Invoice",PurchInvHeader)
              else
                Page.Run(Page::"Posted Purchase Invoices",PurchInvHeader);
            Database::"Purch. Cr. Memo Hdr.":
              if "No. of Records" = 1 then
                Page.Run(Page::"Posted Purchase Credit Memo",PurchCrMemoHeader)
              else
                Page.Run(Page::"Posted Purchase Credit Memos",PurchCrMemoHeader);
            Database::"Return Shipment Header":
              if "No. of Records" = 1 then
                Page.Run(Page::"Posted Return Shipment",ReturnShptHeader)
              else
                Page.Run(0,ReturnShptHeader);
            Database::"Purch. Rcpt. Header":
              if "No. of Records" = 1 then
                Page.Run(Page::"Posted Purchase Receipt",PurchRcptHeader)
              else
                Page.Run(0,PurchRcptHeader);
            Database::"Production Order":
              Page.Run(0,ProductionOrderHeader);
            Database::"Posted Assembly Header":
              if "No. of Records" = 1 then
                Page.Run(Page::"Posted Assembly Order",PostedAssemblyHeader)
              else
                Page.Run(0,PostedAssemblyHeader);
            Database::"Transfer Shipment Header":
              if "No. of Records" = 1 then
                Page.Run(Page::"Posted Transfer Shipment",TransShptHeader)
              else
                Page.Run(0,TransShptHeader);
            Database::"Transfer Receipt Header":
              if "No. of Records" = 1 then
                Page.Run(Page::"Posted Transfer Receipt",TransRcptHeader)
              else
                Page.Run(0,TransRcptHeader);
            Database::"Posted Whse. Shipment Line":
              Page.Run(0,PostedWhseShptLine);
            Database::"Posted Whse. Receipt Line":
              Page.Run(0,PostedWhseRcptLine);
            Database::"G/L Entry":
              Page.Run(0,GLEntry);
            Database::"VAT Entry":
              Page.Run(0,VATEntry);
            Database::"Detailed Cust. Ledg. Entry":
              Page.Run(0,DtldCustLedgEntry);
            Database::"Cust. Ledger Entry":
              Page.Run(0,CustLedgEntry);
            Database::"Reminder/Fin. Charge Entry":
              Page.Run(0,ReminderEntry);
            Database::"Vendor Ledger Entry":
              Page.Run(0,VendLedgEntry);
            Database::"Detailed Vendor Ledg. Entry":
              Page.Run(0,DtldVendLedgEntry);
            Database::"Item Ledger Entry":
              Page.Run(0,ItemLedgEntry);
            Database::"Value Entry":
              Page.Run(0,ValueEntry);
            Database::"Phys. Inventory Ledger Entry":
              Page.Run(0,PhysInvtLedgEntry);
            Database::"Res. Ledger Entry":
              Page.Run(0,ResLedgEntry);
            Database::"Job Ledger Entry":
              Page.Run(0,JobLedgEntry);
            Database::"Job WIP Entry":
              Page.Run(0,JobWIPEntry);
            Database::"Job WIP G/L Entry":
              Page.Run(0,JobWIPGLEntry);
            Database::"Bank Account Ledger Entry":
              Page.Run(0,BankAccLedgEntry);
            Database::"Check Ledger Entry":
              Page.Run(0,CheckLedgEntry);
            Database::"FA Ledger Entry":
              Page.Run(0,FALedgEntry);
            Database::"Maintenance Ledger Entry":
              Page.Run(0,MaintenanceLedgEntry);
            Database::"Ins. Coverage Ledger Entry":
              Page.Run(0,InsuranceCovLedgEntry);
            Database::"Capacity Ledger Entry":
              Page.Run(0,CapacityLedgEntry);
            Database::"Warehouse Entry":
              Page.Run(0,WhseEntry);
            Database::"Service Header":
              ShowServiceHeaderRecords;
            Database::"Service Invoice Header":
              if "No. of Records" = 1 then
                Page.Run(Page::"Posted Service Invoice",ServInvHeader)
              else
                Page.Run(0,ServInvHeader);
            Database::"Service Cr.Memo Header":
              if "No. of Records" = 1 then
                Page.Run(Page::"Posted Service Credit Memo",ServCrMemoHeader)
              else
                Page.Run(0,ServCrMemoHeader);
            Database::"Service Shipment Header":
              if "No. of Records" = 1 then
                Page.Run(Page::"Posted Service Shipment",ServShptHeader)
              else
                Page.Run(0,ServShptHeader);
            Database::"Service Ledger Entry":
              Page.Run(0,ServLedgerEntry);
            Database::"Warranty Ledger Entry":
              Page.Run(0,WarrantyLedgerEntry);
            Database::"Cost Entry":
              Page.Run(0,CostEntry);
            Database::"Posted Deposit Header":
              Page.Run(0,PostedDepositHeader);
            Database::"Posted Deposit Line":
              Page.Run(0,PostedDepositLine);
          end;

        OnAfterNavigateShowRecords("Table ID",DocNoFilter,PostingDateFilter,ItemTrackingSearch);
    end;

    local procedure ShowSalesHeaderRecords()
    begin
        TestField("Table ID",Database::"Sales Header");

        case "Document Type" of
          "document type"::Order:
            if "No. of Records" = 1 then
              Page.Run(Page::"Sales Order",SOSalesHeader)
            else
              Page.Run(0,SOSalesHeader);
          "document type"::Invoice:
            if "No. of Records" = 1 then
              Page.Run(Page::"Sales Invoice",SISalesHeader)
            else
              Page.Run(0,SISalesHeader);
          "document type"::"Return Order":
            if "No. of Records" = 1 then
              Page.Run(Page::"Sales Return Order",SROSalesHeader)
            else
              Page.Run(0,SROSalesHeader);
          "document type"::"Credit Memo":
            if "No. of Records" = 1 then
              Page.Run(Page::"Sales Credit Memo",SCMSalesHeader)
            else
              Page.Run(0,SCMSalesHeader);
        end;
    end;

    local procedure ShowServiceHeaderRecords()
    begin
        TestField("Table ID",Database::"Service Header");

        case "Document Type" of
          "document type"::Order:
            if "No. of Records" = 1 then
              Page.Run(Page::"Service Order",SOServHeader)
            else
              Page.Run(0,SOServHeader);
          "document type"::Invoice:
            if "No. of Records" = 1 then
              Page.Run(Page::"Service Invoice",SIServHeader)
            else
              Page.Run(0,SIServHeader);
          "document type"::"Credit Memo":
            if "No. of Records" = 1 then
              Page.Run(Page::"Service Credit Memo",SCMServHeader)
            else
              Page.Run(0,SCMServHeader);
        end;
    end;

    local procedure SetPostingDate(PostingDate: Text)
    begin
        if ApplicationManagement.MakeDateFilter(PostingDate) = 0 then;
        SetFilter("Posting Date",PostingDate);
        PostingDateFilter := GetFilter("Posting Date");
    end;

    local procedure SetDocNo(DocNo: Text)
    begin
        SetFilter("Document No.",DocNo);
        DocNoFilter := GetFilter("Document No.");
        PostingDateFilter := GetFilter("Posting Date");
    end;


    procedure SetExternal()
    begin
        NavigateDeposit := true;
    end;

    local procedure ClearSourceInfo()
    begin
        if DocExists then begin
          DocExists := false;
          DeleteAll;
          ShowEnable := false;
          SetSource(0D,'','',0,'');
          CurrPage.Update(false);
        end;
    end;

    local procedure MakeExtFilter(var DateFilter: Text;AddDate: Date;var DocNoFilter: Text;AddDocNo: Code[20])
    begin
        if DateFilter = '' then
          DateFilter := Format(AddDate)
        else
          if StrPos(DateFilter,Format(AddDate)) = 0 then
            if MaxStrLen(DateFilter) >= StrLen(DateFilter + '|' + Format(AddDate)) then
              DateFilter := DateFilter + '|' + Format(AddDate)
            else
              TooLongFilter;

        if DocNoFilter = '' then
          DocNoFilter := AddDocNo
        else
          if StrPos(DocNoFilter,AddDocNo) = 0 then
            if MaxStrLen(DocNoFilter) >= StrLen(DocNoFilter + '|' + AddDocNo) then
              DocNoFilter := DocNoFilter + '|' + AddDocNo
            else
              TooLongFilter;
    end;

    local procedure FindPush()
    begin
        if NavigateDeposit then
          FindDepositRecords
        else
          if (DocNoFilter = '') and (PostingDateFilter = '') and
             (not ItemTrackingSearch) and
             ((ContactType <> 0) or (ContactNo <> '') or (ExtDocNo <> ''))
          then
            FindExtRecords
          else
            if ItemTrackingSearch and
               (DocNoFilter = '') and (PostingDateFilter = '') and
               (ContactType = 0) and (ContactNo = '') and (ExtDocNo = '')
            then
              FindTrackingRecords
            else
              FindRecords;
    end;

    local procedure TooLongFilter()
    begin
        if ContactNo = '' then
          Error(Text015);

        Error(Text016);
    end;

    local procedure FindUnpostedSalesDocs(DocType: Option;DocTableName: Text[100];var SalesHeader: Record "Sales Header")
    begin
        SalesHeader."SECURITYFILTERING"(Securityfilter::Filtered);
        if SalesHeader.ReadPermission then begin
          SalesHeader.Reset;
          SalesHeader.SetCurrentkey("Sell-to Customer No.","External Document No.");
          SalesHeader.SetFilter("Sell-to Customer No.",ContactNo);
          SalesHeader.SetFilter("External Document No.",ExtDocNo);
          SalesHeader.SetRange("Document Type",DocType);
          InsertIntoDocEntry(Database::"Sales Header",DocType,DocTableName,SalesHeader.Count);
        end;
    end;

    local procedure FindUnpostedServDocs(DocType: Option;DocTableName: Text[100];var ServHeader: Record "Service Header")
    begin
        ServHeader."SECURITYFILTERING"(Securityfilter::Filtered);
        if ServHeader.ReadPermission then
          if ExtDocNo = '' then begin
            ServHeader.Reset;
            ServHeader.SetCurrentkey("Customer No.");
            ServHeader.SetFilter("Customer No.",ContactNo);
            ServHeader.SetRange("Document Type",DocType);
            InsertIntoDocEntry(Database::"Service Header",DocType,DocTableName,ServHeader.Count);
          end;
    end;

    local procedure FindTrackingRecords()
    var
        DocNoOfRecords: Integer;
    begin
        Window.Open(Text002);
        DeleteAll;
        "Entry No." := 0;

        Clear(ItemTrackingNavigateMgt);
        ItemTrackingNavigateMgt.FindTrackingRecords(SerialNoFilter,LotNoFilter,'','');

        ItemTrackingNavigateMgt.Collect(TempRecordBuffer);
        TempRecordBuffer.SetCurrentkey("Table No.","Search Record ID");
        if TempRecordBuffer.Find('-') then
          repeat
            TempRecordBuffer.SetRange("Table No.",TempRecordBuffer."Table No.");

            DocNoOfRecords := 0;
            if TempRecordBuffer.Find('-') then
              repeat
                TempRecordBuffer.SetRange("Search Record ID",TempRecordBuffer."Search Record ID");
                TempRecordBuffer.Find('+');
                TempRecordBuffer.SetRange("Search Record ID");
                DocNoOfRecords += 1;
              until TempRecordBuffer.Next = 0;

            InsertIntoDocEntry(
              TempRecordBuffer."Table No.",0,TempRecordBuffer."Table Name",DocNoOfRecords);

            TempRecordBuffer.SetRange("Table No.");
          until TempRecordBuffer.Next = 0;

        DocExists := Find('-');

        UpdateFormAfterFindRecords;
        Window.Close;
    end;


    procedure SetTracking(SerialNo: Code[20];LotNo: Code[20])
    begin
        NewSerialNo := SerialNo;
        NewLotNo := LotNo;
    end;

    local procedure ItemTrackingSearch(): Boolean
    begin
        exit((SerialNoFilter <> '') or (LotNoFilter <> ''));
    end;

    local procedure ClearTrackingInfo()
    begin
        SerialNoFilter := '';
        LotNoFilter := '';
    end;

    local procedure ClearInfo()
    begin
        SetDocNo('');
        SetPostingDate('');
        ContactType := Contacttype::" ";
        ContactNo := '';
        ExtDocNo := '';
    end;

    local procedure FindDepositRecords()
    begin
        Window.Open(Text002);
        DeleteAll;
        "Entry No." := 0;
        if GLEntry.ReadPermission then begin
          GLEntry.Reset;
          if not GLEntry.SetCurrentkey("External Document No.","Posting Date") then
            Error(USText001);
          GLEntry.SetFilter("External Document No.",ExtDocNo);
          GLEntry.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"G/L Entry",0,GLEntry.TableCaption,GLEntry.Count);
        end;
        if CustLedgEntry.ReadPermission then begin
          CustLedgEntry.Reset;
          if not CustLedgEntry.SetCurrentkey("External Document No.","Posting Date") then
            Error(USText001);
          CustLedgEntry.SetFilter("External Document No.",ExtDocNo);
          CustLedgEntry.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Cust. Ledger Entry",0,CustLedgEntry.TableCaption,CustLedgEntry.Count);
        end;
        if VendLedgEntry.ReadPermission then begin
          VendLedgEntry.Reset;
          if not VendLedgEntry.SetCurrentkey("External Document No.","Posting Date") then
            Error(USText001);
          VendLedgEntry.SetFilter("External Document No.",ExtDocNo);
          VendLedgEntry.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Vendor Ledger Entry",0,VendLedgEntry.TableCaption,VendLedgEntry.Count);
        end;
        if BankAccLedgEntry.ReadPermission then begin
          BankAccLedgEntry.Reset;
          if not BankAccLedgEntry.SetCurrentkey("External Document No.","Posting Date") then
            Error(USText001);
          BankAccLedgEntry.SetFilter("External Document No.",ExtDocNo);
          BankAccLedgEntry.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Bank Account Ledger Entry",0,BankAccLedgEntry.TableCaption,BankAccLedgEntry.Count);
        end;
        if PostedDepositHeader.ReadPermission then begin
          PostedDepositHeader.Reset;
          PostedDepositHeader.SetFilter("No.",ExtDocNo);
          InsertIntoDocEntry(
            Database::"Posted Deposit Header",0,PostedDepositHeader.TableCaption,PostedDepositHeader.Count);
        end;
        if PostedDepositLine.ReadPermission then begin
          PostedDepositLine.Reset;
          PostedDepositLine.SetCurrentkey("Deposit No.");
          PostedDepositLine.SetFilter("Deposit No.",ExtDocNo);
          PostedDepositLine.SetFilter("Posting Date",PostingDateFilter);
          InsertIntoDocEntry(
            Database::"Posted Deposit Line",0,PostedDepositLine.TableCaption,PostedDepositLine.Count);
        end;
        DocExists := FindFirst;

        SetSource(0D,'','',0,'');
        if DocExists then begin
          if NoOfRecords(Database::"Posted Deposit Header") = 1 then begin
            PostedDepositHeader.FindFirst;
            SetSource(
              PostedDepositHeader."Posting Date",Format("Table Name"),PostedDepositHeader."No.",
              4,PostedDepositHeader."Bank Account No.");
          end else begin
            if ExtDocNo <> '' then
              if PostingDateFilter = '' then
                Message(Text011)
              else
                Message(Text012);
          end;
        end else
          if PostingDateFilter = '' then
            Message(Text013)
          else
            Message(Text014);

        UpdateFormAfterFindRecords;
        Window.Close;
    end;

    local procedure DocNoFilterOnAfterValidate()
    begin
        ClearSourceInfo;
    end;

    local procedure PostingDateFilterOnAfterValida()
    begin
        ClearSourceInfo;
    end;

    local procedure ExtDocNoOnAfterValidate()
    begin
        ClearSourceInfo;
    end;

    local procedure ContactTypeOnAfterValidate()
    begin
        ClearSourceInfo;
    end;

    local procedure ContactNoOnAfterValidate()
    begin
        ClearSourceInfo;
    end;

    local procedure SerialNoFilterOnAfterValidate()
    begin
        ClearSourceInfo;
    end;

    local procedure LotNoFilterOnAfterValidate()
    begin
        ClearSourceInfo;
    end;


    procedure FindRecordsOnOpen()
    begin
        if (NewDocNo = '') and (NewPostingDate = 0D) and (NewSerialNo = '') and (NewLotNo = '') then begin
          DeleteAll;
          ShowEnable := false;
          PrintEnable := false;
          SetSource(0D,'','',0,'');
        end else
          if (NewSerialNo <> '') or (NewLotNo <> '') then begin
            SetSource(0D,'','',0,'');
            SetRange("Serial No. Filter",NewSerialNo);
            SetRange("Lot No. Filter",NewLotNo);
            SerialNoFilter := GetFilter("Serial No. Filter");
            LotNoFilter := GetFilter("Lot No. Filter");
            ClearInfo;
            FindTrackingRecords;
          end else begin
            SetRange("Document No.",NewDocNo);
            SetRange("Posting Date",NewPostingDate);
            PostingDateFilter := GetFilter("Posting Date");
            ContactType := Contacttype::" ";
            ContactNo := '';
            ExtDocNo := '';
            ClearTrackingInfo;
            DocNoFilter := '';
            if NavigateDeposit then begin
              ExtDocNo := GetFilter("Document No.");
              FindDepositRecords;
            end else begin
              DocNoFilter := GetFilter("Document No.");
              FindRecords;
            end;
          end;
    end;


    procedure UpdateNavigateForm(UpdateFormFrom: Boolean)
    begin
        UpdateForm := UpdateFormFrom;
    end;


    procedure ReturnDocumentEntry(var TempDocumentEntry: Record "Document Entry" temporary)
    begin
        SetRange("Table ID");  // Clear filter.
        FindSet;
        repeat
          TempDocumentEntry.Init;
          TempDocumentEntry := Rec;
          TempDocumentEntry.Insert;
        until Next = 0;
    end;

    local procedure UpdateFindByGroupsVisibility()
    begin
        DocumentVisible := false;
        BusinessContactVisible := false;
        ItemReferenceVisible := false;

        case FindBasedOn of
          Findbasedon::Document:
            DocumentVisible := true;
          Findbasedon::"Business Contact":
            BusinessContactVisible := true;
          Findbasedon::"Item Reference":
            ItemReferenceVisible := true;
        end;

        CurrPage.Update;
    end;

    local procedure FilterSelectionChanged()
    begin
        FilterSelectionChangedTxtVisible := true;
    end;

    local procedure GetCaptionText(): Text
    begin
        if "Table Name" <> '' then
          exit(StrSubstNo(PageCaptionTxt,"Table Name"));

        exit('');
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterNavigateFindRecords(var DocumentEntry: Record "Document Entry";DocNoFilter: Text;PostingDateFilter: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterNavigateShowRecords(TableID: Integer;DocNoFilter: Text;PostingDateFilter: Text;ItemTrackingSearch: Boolean)
    begin
    end;
}

