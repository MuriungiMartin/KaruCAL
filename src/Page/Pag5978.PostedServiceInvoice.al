#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5978 "Posted Service Invoice"
{
    Caption = 'Posted Service Invoice';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Service Invoice Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the posted invoice.';
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the customer who owns the items on the invoice.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the name of the customer on the service invoice.';
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the address of the customer on the invoice.';
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies an additional line in the address.';
                }
                field(City;City)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the city of the address.';
                }
                field(County;County)
                {
                    ApplicationArea = Basic;
                    Caption = 'State / ZIP Code';
                    Editable = false;
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the ZIP code of the address.';
                }
                field("Contact Name";"Contact Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the name of the contact person at the customer company.';
                }
                field("Contact No.";"Contact No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the number of the contact at the customer to whom you shipped the service.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the date when the invoice was posted.';
                }
                group(Control11)
                {
                    Visible = DocExchStatusVisible;
                    field("Document Exchange Status";"Document Exchange Status")
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                        StyleExpr = DocExchStatusStyle;

                        trigger OnDrillDown()
                        begin
                            DocExchStatusDrillDown;
                        end;
                    }
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the date when you created the service document.';
                }
                field("Order No.";"Order No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the service order from which this invoice was posted.';
                }
                field("Pre-Assigned No.";"Pre-Assigned No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the number of the service document from which the posted invoice was created.';
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code of the salesperson associated with the invoice.';
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code of the responsibility center (for example, a distribution center) assigned to the customer or associated with the invoice.';
                }
                field("No. Printed";"No. Printed")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies how many times the invoice has been printed.';
                }
            }
            part(ServInvLines;"Posted Service Invoice Subform")
            {
                SubPageLink = "Document No."=field("No.");
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the customer to whom the invoice was sent.';
                }
                field("Bill-to Contact No.";"Bill-to Contact No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the number of the contact to whom you send the invoice for the shipment.';
                }
                field("Bill-to Name";"Bill-to Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the name of the customer to whom you sent the invoice.';
                }
                field("Bill-to Address";"Bill-to Address")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the address of the customer.';
                }
                field("Bill-to Address 2";"Bill-to Address 2")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies an additional line of the address.';
                }
                field("Bill-to City";"Bill-to City")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the city of the customer address.';
                }
                field("Bill-to County";"Bill-to County")
                {
                    ApplicationArea = Basic;
                    Caption = ' State / ZIP Code';
                    Editable = false;
                }
                field("Bill-to Post Code";"Bill-to Post Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the ZIP code of the address.';
                }
                field("Bill-to Contact";"Bill-to Contact")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the name of the contact person to whom you sent the invoice.';
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the dimension value code associated to this invoice.';
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the dimension value code associated to this invoice.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date when the invoice is due for payment.';
                }
                field("Tax Liable";"Tax Liable")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Tax Area Code";"Tax Area Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code of the customer'' s address.';
                }
                field("Ship-to Name";"Ship-to Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the name of the customer to whom the service on the invoice was shipped.';
                }
                field("Ship-to Address";"Ship-to Address")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the address to which the service on the invoice was shipped.';
                }
                field("Ship-to Address 2";"Ship-to Address 2")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies an additional line of the address.';
                }
                field("Ship-to City";"Ship-to City")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the city of the address.';
                }
                field("Ship-to County";"Ship-to County")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ship-to State / ZIP Code';
                    Editable = false;
                }
                field("Ship-to Post Code";"Ship-to Post Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the ZIP code of the address.';
                }
                field("Ship-to Contact";"Ship-to Contact")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the name of the contact person at the location where the service has been shipped to.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the location, such as warehouse or distribution center, from which the service was shipped.';
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the currency code for the amounts on the invoice.';

                    trigger OnAssistEdit()
                    begin
                        ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date");
                        ChangeExchangeRate.Editable(false);
                        if ChangeExchangeRate.RunModal = Action::OK then begin
                          "Currency Factor" := ChangeExchangeRate.GetParameter;
                          Modify;
                        end;
                        Clear(ChangeExchangeRate);
                    end;
                }
                field("EU 3-Party Trade";"EU 3-Party Trade")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies that the invoice was a part of an EU 3-party trade transaction.';
                }
            }
            group("Electronic Invoice")
            {
                Caption = 'Electronic Invoice';
                field("Electronic Document Status";"Electronic Document Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the status of the document.';
                }
                field("Date/Time Stamped";"Date/Time Stamped")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date and time that the document received a digital stamp from the authorized service provider.';
                }
                field("Date/Time Sent";"Date/Time Sent")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date and time that the document was sent to the customer.';
                }
                field("Date/Time Canceled";"Date/Time Canceled")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date and time that the document was canceled.';
                }
                field("Error Code";"Error Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the error code that the authorized service provider, PAC, has returned to Microsoft Dynamics NAV.';
                }
                field("Error Description";"Error Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the error message that the authorized service provider, PAC, has returned to Microsoft Dynamics NAV.';
                }
                field("PAC Web Service Name";"PAC Web Service Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the authorized service provider, PAC, which has processed the electronic document.';
                }
                field("Fiscal Invoice Number PAC";"Fiscal Invoice Number PAC")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the official invoice number for the electronic document.';
                }
                field("No. of E-Documents Sent";"No. of E-Documents Sent")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of times that this document has been sent electronically.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Invoice")
            {
                Caption = '&Invoice';
                Image = Invoice;
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    begin
                        if "Tax Area Code" = '' then
                          Page.RunModal(Page::"Service Invoice Statistics",Rec,"No.")
                        else
                          Page.RunModal(Page::"Service Invoice Stats.",Rec,"No.");
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Service Comment Sheet";
                    RunPageLink = Type=const(General),
                                  "Table Name"=const("Service Invoice Header"),
                                  "No."=field("No.");
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                        CurrPage.SaveRecord;
                    end;
                }
                separator(Action34)
                {
                }
                action("Service Document Lo&g")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Document Lo&g';
                    Image = Log;

                    trigger OnAction()
                    var
                        ServDocLog: Record "Service Document Log";
                        TempServDocLog: Record "Service Document Log" temporary;
                    begin
                        TempServDocLog.Reset;
                        TempServDocLog.DeleteAll;

                        ServDocLog.Reset;
                        ServDocLog.SetRange("Document Type",ServDocLog."document type"::"Posted Invoice");
                        ServDocLog.SetRange("Document No.","No.");
                        if ServDocLog.FindSet then
                          repeat
                            TempServDocLog := ServDocLog;
                            TempServDocLog.Insert;
                          until ServDocLog.Next = 0;

                        ServDocLog.Reset;
                        ServDocLog.SetRange("Document Type",ServDocLog."document type"::Order);
                        ServDocLog.SetRange("Document No.","Order No.");
                        if ServDocLog.FindSet then
                          repeat
                            TempServDocLog := ServDocLog;
                            TempServDocLog.Insert;
                          until ServDocLog.Next = 0;

                        ServDocLog.Reset;
                        ServDocLog.SetRange("Document Type",ServDocLog."document type"::Invoice);
                        ServDocLog.SetRange("Document No.","Pre-Assigned No.");
                        if ServDocLog.FindSet then
                          repeat
                            TempServDocLog := ServDocLog;
                            TempServDocLog.Insert;
                          until ServDocLog.Next = 0;

                        TempServDocLog.Reset;
                        TempServDocLog.SetCurrentkey("Change Date","Change Time");
                        TempServDocLog.Ascending(false);

                        Page.Run(0,TempServDocLog);
                    end;
                }
            }
        }
        area(processing)
        {
            group("&Electronic Document")
            {
                Caption = '&Electronic Document';
                action("S&end")
                {
                    ApplicationArea = Basic;
                    Caption = 'S&end';
                    Ellipsis = true;
                    Image = SendTo;

                    trigger OnAction()
                    begin
                        RequestStampEDocument;
                    end;
                }
                action("Export E-Document as &XML")
                {
                    ApplicationArea = Basic;
                    Caption = 'Export E-Document as &XML';
                    Image = ExportElectronicDocument;

                    trigger OnAction()
                    begin
                        ExportEDocument;
                    end;
                }
                action("&Cancel")
                {
                    ApplicationArea = Basic;
                    Caption = '&Cancel';
                    Image = Cancel;

                    trigger OnAction()
                    begin
                        CancelEDocument;
                    end;
                }
            }
            action(SendCustom)
            {
                ApplicationArea = Basic;
                Caption = 'Send';
                Ellipsis = true;
                Image = SendToMultiple;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ServiceInvHeader := Rec;
                    CurrPage.SetSelectionFilter(ServiceInvHeader);
                    ServiceInvHeader.SendRecords;
                end;
            }
            action("&Print")
            {
                ApplicationArea = Basic;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(ServiceInvHeader);
                    ServiceInvHeader.PrintRecords(true);
                end;
            }
            action("&Navigate")
            {
                ApplicationArea = Basic;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Navigate;
                end;
            }
            action(ActivityLog)
            {
                ApplicationArea = Basic;
                Caption = 'Activity Log';
                Image = Log;

                trigger OnAction()
                begin
                    ShowActivityLog;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        DocExchStatusStyle := GetDocExchStatusStyle;
        DocExchStatusVisible := "Document Exchange Status" <> "document exchange status"::"Not Sent";
    end;

    trigger OnAfterGetRecord()
    begin
        DocExchStatusStyle := GetDocExchStatusStyle;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        if Find(Which) then
          exit(true);
        SetRange("No.");
        exit(Find(Which));
    end;

    trigger OnOpenPage()
    begin
        SetSecurityFilterOnRespCenter;
    end;

    var
        ServiceInvHeader: Record "Service Invoice Header";
        ChangeExchangeRate: Page "Change Exchange Rate";
        DocExchStatusStyle: Text;
        DocExchStatusVisible: Boolean;
}

