#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51701 "Post 0.01"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Post 0.01.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "Customer Type";
            column(ReportForNavId_6836; 6836)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Customer__No__;"No.")
            {
            }
            column(Customer_Name;Name)
            {
            }
            column(CustomerCaption;CustomerCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Customer__No__Caption;FieldCaption("No."))
            {
            }
            column(Customer_NameCaption;FieldCaption(Name))
            {
            }
            dataitem("Cust. Ledger Entry";"Cust. Ledger Entry")
            {
                DataItemLink = "Customer No."=field("No.");
                DataItemTableView = where(Open=const(true));
                column(ReportForNavId_8503; 8503)
                {
                }
                column(Cust__Ledger_Entry__Remaining_Amt___LCY__;"Remaining Amt. (LCY)")
                {
                }
                column(Cust__Ledger_Entry_Entry_No_;"Entry No.")
                {
                }
                column(Cust__Ledger_Entry_Customer_No_;"Customer No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if "Cust. Ledger Entry"."Remaining Amt. (LCY)" > 0 then
                    OpenD:=true
                    else
                    OpenC:=true
                end;

                trigger OnPostDataItem()
                begin
                    if (OpenD=true) and (OpenC=true) then begin
                    LNo:=LNo+10000;

                    GenJnl.Init;
                    GenJnl."Line No." := LNo;
                    GenJnl."Posting Date":=Today;
                    GenJnl."Document No.":='';
                    GenJnl.Validate(GenJnl."Document No.");
                    GenJnl."Journal Template Name":='SALES';
                    GenJnl."Journal Batch Name":='RND';
                    GenJnl."Account Type":=GenJnl."account type"::Customer;
                    GenJnl."Account No.":="Cust. Ledger Entry"."Customer No.";
                    GenJnl.Amount:=0.01;
                    GenJnl.Validate(GenJnl."Account No.");
                    GenJnl.Validate(GenJnl.Amount);
                    GenJnl.Description:='Rounding Adj';
                    GenJnl.Insert;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                OpenD:=false;
                OpenC:=false;
            end;

            trigger OnPostDataItem()
            begin
                //MESSAGE('ha');
                /*
                IF (OpenD=TRUE) AND (OpenC=TRUE) THEN BEGIN
                LNo:=LNo+10000;
                
                GenJnl.INIT;
                GenJnl."Line No." := LNo;
                GenJnl."Posting Date":=TODAY;
                GenJnl."Document No.":='';
                GenJnl.VALIDATE(GenJnl."Document No.");
                GenJnl."Journal Template Name":='SALES';
                GenJnl."Journal Batch Name":='RND';
                GenJnl."Account Type":=GenJnl."Account Type"::Customer;
                GenJnl."Account No.":="No.";
                GenJnl.Amount:=0.01;
                GenJnl.VALIDATE(GenJnl."Account No.");
                GenJnl.VALIDATE(GenJnl.Amount);
                GenJnl.Description:='Rounding Adj';
                GenJnl.INSERT;
                END;
                */

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
        OpenD: Boolean;
        OpenC: Boolean;
        GenJnl: Record "Gen. Journal Line";
        LNo: Integer;
        CustomerCaptionLbl: label 'Customer';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

