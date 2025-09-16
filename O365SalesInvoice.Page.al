#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 2110 "O365 Sales Invoice"
{
    Caption = 'Draft Invoice';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Sales Header";
    SourceTableView = where("Document Type"=const(Invoice));

    layout
    {
        area(content)
        {
            group(Invoice)
            {
                Caption = 'Invoice';
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the record.';
                }
                field(CustomerName;CustomerName)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Customer Name';
                    Editable = CurrPageEditable;
                    Importance = Promoted;
                    Lookup = true;
                    ShowMandatory = true;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if LookupCustomerName(Text) then
                          CustomerEmail := GetCustomerEmail;
                    end;

                    trigger OnValidate()
                    var
                        Customer: Record Customer;
                    begin
                        if not Customer.Get(Customer.GetCustNoOpenCard(CustomerName,false)) then begin
                          if Customer.IsLookupRequested then
                            if LookupCustomerName(CustomerName) then
                              exit;
                          Error('');
                        end;

                        SetHideValidationDialog(true);
                        Validate("Sell-to Customer Name",CustomerName);
                        CustomerName := "Sell-to Customer Name";
                        CustomerEmail := GetCustomerEmail;
                        if CustomerName <> '' then
                          CustomerExists := true;
                    end;
                }
                field(CustomerEmail;CustomerEmail)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'E-mail';
                    Editable = CurrPageEditable and CustomerExists;
                    ExtendedDatatype = EMail;

                    trigger OnValidate()
                    var
                        Customer: Record Customer;
                    begin
                        if (CustomerEmail <> '') and ("Sell-to Customer No." <> '') and Customer.WritePermission then
                          if Customer.Get("Sell-to Customer No.") then
                            if CustomerEmail <> Customer."E-Mail" then begin
                              Customer."E-Mail" := CustomerEmail;
                              Customer.Modify;
                            end;
                    end;
                }
                field("Sell-to Address";"Sell-to Address")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Address';
                    Editable = CustomerExists;
                    Importance = Additional;
                    ToolTip = 'Specifies the customer''s sell-to address.';
                }
                field("Sell-to Address 2";"Sell-to Address 2")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Address 2';
                    Editable = CustomerExists;
                    Importance = Additional;
                    ToolTip = 'Specifies an additional part of the customer''s sell-to address.';
                }
                field("Sell-to City";"Sell-to City")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'City';
                    Editable = CustomerExists;
                    Importance = Additional;
                }
                field("Sell-to Post Code";"Sell-to Post Code")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'ZIP Code';
                    Editable = CustomerExists;
                    Importance = Additional;
                }
                field("Sell-to County";"Sell-to County")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'State';
                    Editable = CustomerExists;
                    Importance = Additional;
                }
                field("Sell-to Country/Region Code";"Sell-to Country/Region Code")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Country/Region';
                    Editable = CustomerExists;
                    Importance = Additional;
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Invoice Date';
                    Editable = CustomerExists;
                    Importance = Additional;
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = CustomerExists;
                    Importance = Additional;
                    ToolTip = 'Specifies when the sales invoice must be paid.';
                }
                field("Tax Liable";"Tax Liable")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = CustomerExists;
                    Importance = Additional;
                }
                field("Tax Area Code";"Tax Area Code")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = CustomerExists;
                    Importance = Additional;
                }
                field(WorkDescription;WorkDescription)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Work Description';
                    Editable = CurrPageEditable and CustomerExists;
                    Importance = Additional;
                    MultiLine = true;
                    ShowCaption = false;
                    ToolTip = 'Specifies the products or service being offered';

                    trigger OnValidate()
                    begin
                        SetWorkDescription(WorkDescription);
                    end;
                }
            }
            part(Control21;"O365 Sales Invoice Line Subp.")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Lines';
                Editable = CustomerExists;
                SubPageLink = "Document Type"=field("Document Type"),
                              "Document No."=field("No.");
                UpdatePropagation = Both;
            }
            field(Amount;Amount)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Net Total';
                Importance = Additional;
                Visible = false;
            }
            field("Amount Including VAT";"Amount Including VAT")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Total Including Tax';
                DrillDown = false;
                Importance = Promoted;
                Lookup = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Post)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Send the invoice';
                Image = PostSendTo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ShortCutKey = 'Ctrl+Right';
                ToolTip = 'Finalize and send the invoice.';

                trigger OnAction()
                var
                    AssistedSetup: Record "Assisted Setup";
                    MailManagement: Codeunit "Mail Management";
                begin
                    if AssistedSetup.GetStatus(Page::"Email Setup Wizard") = AssistedSetup.Status::"Not Completed" then begin
                      Page.RunModal(Page::"Email Setup Wizard");
                      if AssistedSetup.GetStatus(Page::"Email Setup Wizard") = AssistedSetup.Status::"Not Completed" then
                        Error(MailNotConfiguredErr);
                    end;

                    SendToPosting(Codeunit::"Sales-Post + Email");

                    if (CustomerEmail <> '') and MailManagement.IsSMTPEnabled then
                      Message(InvoiceSentMsg);

                    KeepInvoice := true;
                end;
            }
            action(ViewPdf)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Preview Invoice';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'View the preview of the invoice before sending.';

                trigger OnAction()
                var
                    ReportSelections: Record "Report Selections";
                    ReportViewer: Page "Report Viewer";
                begin
                    SetRecfilter;
                    LockTable;
                    Find;
                    ReportViewer.SetDocument(Rec,ReportSelections.Usage::"S.Invoice Draft","Sell-to Customer No.");
                    ReportViewer.Run;
                    Find;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CustomerName := "Sell-to Customer Name";
        CustomerEmail := GetCustomerEmail;
        WorkDescription := GetWorkDescription;
        CurrPageEditable := CurrPage.Editable;
        CustomerExists := "Sell-to Customer No." <> '';
    end;

    trigger OnInit()
    begin
        KeepInvoice := "No." <> '';
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "Document Type" := "document type"::Invoice;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        CustomerName := '';
        CustomerEmail := '';
        WorkDescription := '';

        SetDefaultPaymentServices;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        // If the invoice has just been created, or no customer is specified
        if GuiAllowed and
           ("No." <> '') and
           (not (KeepInvoice and CustomerExists))
        then
          exit(ProcessDraftInvoiceOnCreate);
    end;

    var
        CustomerName: Text[50];
        InvoiceSentMsg: label 'Your invoice is sent.';
        CustomerEmail: Text[80];
        WorkDescription: Text;
        CurrPageEditable: Boolean;
        CustomerExists: Boolean;
        ProcessDraftInvoiceOptionQst: label 'Keep,Discard';
        ProcessDraftInvoiceInstructionTxt: label 'Do you want to keep new invoice?';
        KeepInvoice: Boolean;
        MailNotConfiguredErr: label 'An email account must be configured to send an invoice.';

    local procedure LookupCustomerName(Text: Text): Boolean
    var
        Customer: Record Customer;
        O365CustomerLookup: Page "O365 Customer Lookup";
    begin
        if Text <> '' then begin
          Customer.SetRange(Name,Text);
          if Customer.FindFirst then;
          Customer.SetRange(Name);
        end;

        O365CustomerLookup.LookupMode(true);
        O365CustomerLookup.SetRecord(Customer);

        if O365CustomerLookup.RunModal = Action::LookupOK then begin
          O365CustomerLookup.GetRecord(Customer);
          SetHideValidationDialog(true);
          CustomerName := Customer.Name;
          Validate("Sell-to Customer Name",CustomerName);
          if CustomerName <> '' then
            CustomerExists := true;
          exit(true);
        end;

        exit(false);
    end;

    local procedure GetCustomerEmail(): Text[80]
    var
        Customer: Record Customer;
    begin
        if "Sell-to Customer No." <> '' then
          if Customer.Get("Sell-to Customer No.") then
            exit(Customer."E-Mail");
        exit('');
    end;

    local procedure ProcessDraftInvoiceOnCreate(): Boolean
    var
        OptionNumber: Integer;
    begin
        OptionNumber := StrMenu(ProcessDraftInvoiceOptionQst,1,ProcessDraftInvoiceInstructionTxt);

        if OptionNumber = 1 then
          exit(true);

        if OptionNumber = 2 then
          exit(Delete(true)); // Delete all invoice lines and invoice header
    end;
}

