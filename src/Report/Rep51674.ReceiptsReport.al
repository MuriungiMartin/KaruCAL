#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51674 "Receipts Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Receipts Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61723;UnknownTable61723)
        {
            RequestFilterFields = "No.";
            column(ReportForNavId_1102755004; 1102755004)
            {
            }
            column(HeaderNo;"FIN-Receipts Header"."No.")
            {
            }
            column(HeaderDate;"FIN-Receipts Header".Date)
            {
            }
            column(UserID;"FIN-Receipts Header".Cashier)
            {
            }
            column(AcctName;AcctName)
            {
            }
            column(RegNo;RegNo)
            {
            }
            column(RecFrom;"FIN-Receipts Header"."Received From")
            {
            }
            column(CheqNo;"FIN-Receipts Header"."Cheque No.")
            {
            }
            column(AmountReceived;"FIN-Receipts Header"."Amount Recieved")
            {
            }
            column(UserName;'You were served by: '+UserName)
            {
            }
            column(pic;CompanyInfo.Picture)
            {
            }
            column(log;CompanyInfo.Picture)
            {
            }
            dataitem(UnknownTable61717;UnknownTable61717)
            {
                DataItemLink = No=field("No.");
                column(ReportForNavId_1102755006; 1102755006)
                {
                }
                column(RecLineNo;"FIN-Receipt Line q"."Account No.")
                {
                }
                column(RecLineAcctName;"FIN-Receipt Line q"."Account Name")
                {
                }
                column(Amount;"FIN-Receipt Line q".Amount)
                {
                }
                column(TotalAmount;TotalAmount)
                {
                }
                column(NumberText_1_;NumberText[1])
                {
                }
                column(PayMode;"FIN-Receipt Line q"."Pay Mode")
                {
                }
                column(TRanName;"FIN-Receipt Line q"."Transaction Name")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    TotalAmount:=TotalAmount+"FIN-Receipt Line q".Amount;

                    //CheckReport.InitTextVariable;
                    //CheckReport.FormatNoText(NumberText,TotalAmount,'');
                end;
            }

            trigger OnAfterGetRecord()
            begin
                TotalAmount:=0;

                Clear(UserName);
                usersTable.Reset;
                usersTable.SetRange(usersTable."User Name","FIN-Receipts Header".Cashier);
                if usersTable.Find('-') then begin
                if usersTable."Full Name"<>'' then
                 UserName:=usersTable."Full Name"
                 else UserName:="FIN-Receipts Header".Cashier;
                end else UserName:="FIN-Receipts Header".Cashier;
                //CheckReport.FormatNoText(NumberText,"Receipts Header"."Amount Recieved",'');

                CheckReport.InitTextVariable();
                CheckReport.FormatNoText(NumberText,"FIN-Receipts Header"."Amount Recieved",'');
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
         CompanyInfo.Reset;
         if CompanyInfo.Find('-') then begin
         CompanyInfo.CalcFields(Picture);
         end;
    end;

    var
        AcctName: Text[150];
        RegNo: Code[30];
        NumberText: array [2] of Text[120];
        CheckReport: Report Check;
        TotalAmount: Decimal;
        UserName: Text[250];
        usersTable: Record User;
        CompanyInfo: Record "Company Information";
        FormatAddr: Codeunit "Format Address";
}

