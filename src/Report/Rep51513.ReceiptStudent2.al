#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51513 "Receipt - Student 2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Receipt - Student 2.rdlc';

    dataset
    {
        dataitem(UnknownTable61538;UnknownTable61538)
        {
            DataItemTableView = sorting("Receipt No.");
            RequestFilterFields = "Receipt No.";
            column(ReportForNavId_5672; 5672)
            {
            }
            column(Receipt__Student_No__;"Student No.")
            {
            }
            column(Receipt__Receipt_No__;"Receipt No.")
            {
            }
            column(Receipt_Date;Date)
            {
            }
            column(Receipt_Amount;Amount)
            {
            }
            column(Names;Names)
            {
            }
            column(TIME;Time)
            {
            }
            column(CPA_Center__Thika_RdCaption;CPA_Center__Thika_RdCaptionLbl)
            {
            }
            dataitem(UnknownTable61539;UnknownTable61539)
            {
                DataItemLink = "Receipt No"=field("Receipt No.");
                column(ReportForNavId_9528; 9528)
                {
                }
                column(Receipt_Items_Balance;Balance)
                {
                }
                column(Receipt_Items_Amount;Amount)
                {
                }
                column(Receipt_Items_Description;Description)
                {
                }
                column(Receipt_Items_Code;Code)
                {
                }
                column(Receipt_Items_Receipt_No;"Receipt No")
                {
                }
                column(Receipt_Items_Uniq_No_2;"Uniq No 2")
                {
                }
                column(Receipt_Items_Transaction_ID;"Transaction ID")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                Cust.Reset;
                if  Cust.Get("ACA-Receipt"."Student No.") then begin
                Cust.CalcFields(Cust.Balance);
                Names :=Cust.Name;
                end;

                //CheckReport.InitTextVariable;
                //CheckReport.FormatNoText(NumberText,Receipt.Amount,'KSH');
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

    var
        Cust: Record Customer;
        Names: Text[200];
        AmountWords: Text[250];
        CheckReport: Report Check;
        NumberText: Text[250];
        CPA_Center__Thika_RdCaptionLbl: label 'CPA Center -Thika Rd';
}

