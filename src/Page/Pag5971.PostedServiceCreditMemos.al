#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5971 "Posted Service Credit Memos"
{
    ApplicationArea = Basic;
    Caption = 'Posted Service Credit Memos';
    CardPageID = "Posted Service Credit Memo";
    Editable = false;
    PageType = List;
    SourceTable = "Service Cr.Memo Header";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the posted credit memo.';
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer associated with the credit memo.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the customer to whom you shipped the service on the credit memo.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the currency code for the amounts on the credit memo.';
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ZIP code of the address.';
                    Visible = false;
                }
                field("Country/Region Code";"Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the country/region code of the customer address.';
                    Visible = false;
                }
                field("Contact Name";"Contact Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the contact person at the customer company.';
                    Visible = false;
                }
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer to whom the credit memo was sent.';
                    Visible = false;
                }
                field("Bill-to Name";"Bill-to Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the customer to whom you sent the credit memo.';
                    Visible = false;
                }
                field("Bill-to Post Code";"Bill-to Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ZIP code of the address.';
                    Visible = false;
                }
                field("Bill-to Country/Region Code";"Bill-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the country/region code of the customer''s billing address.';
                    Visible = false;
                }
                field("Bill-to Contact";"Bill-to Contact")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the contact person to whom you sent the service credit memo.';
                    Visible = false;
                }
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the customer'' s address.';
                    Visible = false;
                }
                field("Ship-to Name";"Ship-to Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the customer to whom the service was shipped.';
                    Visible = false;
                }
                field("Ship-to Post Code";"Ship-to Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ZIP code of the address.';
                    Visible = false;
                }
                field("Ship-to Country/Region Code";"Ship-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the country/region where the service was shipped.';
                    Visible = false;
                }
                field("Ship-to Contact";"Ship-to Contact")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the contact person at the location where the service was shipped.';
                    Visible = false;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the credit memo was posted.';
                    Visible = false;
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the salesperson associated with the credit memo.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code associated to the credit memo.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code associated to the credit memo.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location, such as warehouse or distribution center, where the credit memo was registered.';
                    Visible = true;
                }
                field("Electronic Document Status";"Electronic Document Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the status of the document.';
                }
                field("Date/Time Stamped";"Date/Time Stamped")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date and time that the document received a digital stamp from the authorized service provider.';
                    Visible = false;
                }
                field("Date/Time Sent";"Date/Time Sent")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date and time that the document was sent to the customer.';
                    Visible = false;
                }
                field("Date/Time Canceled";"Date/Time Canceled")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date and time that the document was canceled.';
                    Visible = false;
                }
                field("Error Code";"Error Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the error code that the authorized service provider, PAC, has returned to Microsoft Dynamics NAV.';
                    Visible = false;
                }
                field("Error Description";"Error Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the error message that the authorized service provider, PAC, has returned to Microsoft Dynamics NAV.';
                    Visible = false;
                }
                field("Document Exchange Status";"Document Exchange Status")
                {
                    ApplicationArea = Basic;
                    StyleExpr = DocExchStatusStyle;
                    Visible = DocExchStatusVisible;

                    trigger OnDrillDown()
                    begin
                        DocExchStatusDrillDown;
                    end;
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
            group("&Cr. Memo")
            {
                Caption = '&Cr. Memo';
                Image = CreditMemo;
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
                          Page.RunModal(Page::"Service Credit Memo Statistics",Rec,"No.")
                        else
                          Page.RunModal(Page::"Service Credit Memo Stats.",Rec,"No.");
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Service Comment Sheet";
                    RunPageLink = Type=const(General),
                                  "Table Name"=const("Service Cr.Memo Header"),
                                  "No."=field("No.");
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
                    ServCrMemoHeader := Rec;
                    CurrPage.SetSelectionFilter(ServCrMemoHeader);
                    ServCrMemoHeader.SendRecords;
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
                    CurrPage.SetSelectionFilter(ServCrMemoHeader);
                    ServCrMemoHeader.PrintRecords(true);
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
                var
                    ActivityLog: Record "Activity Log";
                begin
                    ActivityLog.ShowEntries(RecordId);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        DocExchStatusStyle := GetDocExchStatusStyle;
    end;

    trigger OnAfterGetRecord()
    var
        ServiceCrMemoHeader: Record "Service Cr.Memo Header";
    begin
        DocExchStatusStyle := GetDocExchStatusStyle;

        ServiceCrMemoHeader.CopyFilters(Rec);
        ServiceCrMemoHeader.SetFilter("Document Exchange Status",'<>%1',"document exchange status"::"Not Sent");
        DocExchStatusVisible := not ServiceCrMemoHeader.IsEmpty;
    end;

    trigger OnOpenPage()
    begin
        SetSecurityFilterOnRespCenter;
    end;

    var
        ServCrMemoHeader: Record "Service Cr.Memo Header";
        DocExchStatusStyle: Text;
        DocExchStatusVisible: Boolean;
}

