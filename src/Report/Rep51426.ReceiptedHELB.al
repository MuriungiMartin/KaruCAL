#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51426 "Receipted HELB"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Receipted HELB.rdlc';

    dataset
    {
        dataitem(UnknownTable61538;UnknownTable61538)
        {
            DataItemTableView = sorting("Student No.") order(ascending) where("Payment Mode"=const(HELB));
            RequestFilterFields = "Payment By","Student No.";
            column(ReportForNavId_5672; 5672)
            {
            }
            column(userName;userName)
            {
            }
            column(dateToday;dateToday)
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
            column(Receipt__Payment_Mode_;"Payment Mode")
            {
            }
            column(Receipt_Amount;Amount)
            {
            }
            column(Receipt__Payment_By_;"Payment By")
            {
            }
            column(Receipt__User_ID_;"User ID")
            {
            }
            column(Receipt_Amount_Control1102760017;Amount)
            {
            }
            column(Receipt__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(Receipt__Receipt_No__Caption;FieldCaption("Receipt No."))
            {
            }
            column(Receipt_DateCaption;FieldCaption(Date))
            {
            }
            column(Receipt__Payment_Mode_Caption;FieldCaption("Payment Mode"))
            {
            }
            column(Receipt_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Receipt__Payment_By_Caption;FieldCaption("Payment By"))
            {
            }
            column(Receipt__User_ID_Caption;FieldCaption("User ID"))
            {
            }
            column(Receipted_HELBCaption;Receipted_HELBCaptionLbl)
            {
            }

            trigger OnPreDataItem()
            begin
                userName:=UserId;
                dateToday:=Today;
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
        userName: Code[20];
        dateToday: Date;
        Receipted_HELBCaptionLbl: label 'Receipted HELB';
}

