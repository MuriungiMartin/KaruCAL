#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 2129 "O365 Export Invoices"
{
    Caption = 'Export Invoices';
    PageType = List;

    layout
    {
        area(content)
        {
            group(Control2)
            {
                field(StartDate;StartDate)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Start Date';
                    ShowMandatory = true;
                    ToolTip = 'Specifies the starting date of the time period to export invoices';
                }
                field(EndDate;EndDate)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'End Date';
                    ShowMandatory = true;
                    ToolTip = 'Specifies the ending date of the time period to export invoices';
                }
                field(Email;Email)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Email';
                    ShowMandatory = true;
                    ToolTip = 'Specifies the email receipient for the exported invoices';

                    trigger OnValidate()
                    begin
                        MailManagement.CheckValidEmailAddress(Email);
                    end;
                }
                field(ExportInvoicesLbl;ExportInvoicesLbl)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        O365ExportInvoicesEmail.ExportInvoicesToExcelandEmail(StartDate,EndDate,Email);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        Initialize;
    end;

    var
        MailManagement: Codeunit "Mail Management";
        O365ExportInvoicesEmail: Codeunit "O365 Export Invoices + Email";
        StartDate: Date;
        EndDate: Date;
        Email: Text[80];
        ExportInvoicesLbl: label 'Export Invoices';

    local procedure Initialize()
    var
        O365EmailSetup: Record "O365 Email Setup";
    begin
        StartDate := CalcDate('<-CM>',WorkDate);
        EndDate := WorkDate;
        if O365EmailSetup.FindLast then
          Email := O365EmailSetup.Email;
    end;
}

