#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51429 "EARE Receipt V2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/EARE Receipt V2.rdlc';

    dataset
    {
        dataitem("Gen. Journal Line";"Gen. Journal Line")
        {
            DataItemTableView = sorting("Journal Template Name","Journal Batch Name","Line No.");
            RequestFilterFields = "Journal Template Name","Line No.","Journal Batch Name";
            column(ReportForNavId_7024; 7024)
            {
            }
            column(Company_Name;Company.Name)
            {
            }
            column(AddressLine;AddressLine)
            {
            }
            column(Gen__Journal_Line__Posting_Date_;"Posting Date")
            {
            }
            column(Gen__Journal_Line_Description;Description)
            {
            }
            column(Gen__Journal_Line__Amount__LCY__;"Amount (LCY)")
            {
            }
            column(ReceivedFrom;ReceivedFrom)
            {
            }
            column(NumberText_1_;NumberText[1])
            {
            }
            column(USERID;UserId)
            {
            }
            column(Gen__Journal_Line__Pay_Mode_;"Pay Mode")
            {
            }
            column(Gen__Journal_Line__Document_No__;"Document No.")
            {
            }
            column(Received_with_thanks_fromCaption;Received_with_thanks_fromCaptionLbl)
            {
            }
            column(DateCaption;DateCaptionLbl)
            {
            }
            column(Cheque_CashCaption;Cheque_CashCaptionLbl)
            {
            }
            column(Total_AmountCaption;Total_AmountCaptionLbl)
            {
            }
            column(Amount_in_wordsCaption;Amount_in_wordsCaptionLbl)
            {
            }
            column(Detail_of_receiptCaption;Detail_of_receiptCaptionLbl)
            {
            }
            column(Receipt_No_Caption;Receipt_No_CaptionLbl)
            {
            }
            column(Received_by_Caption;Received_by_CaptionLbl)
            {
            }
            column(Gen__Journal_Line_Journal_Template_Name;"Journal Template Name")
            {
            }
            column(Gen__Journal_Line_Journal_Batch_Name;"Journal Batch Name")
            {
            }
            column(Gen__Journal_Line_Line_No_;"Line No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                CheckReport.InitTextVariable;
                CheckReport.FormatNoText(NumberText,"Gen. Journal Line"."Amount (LCY)",'');
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

    trigger OnInitReport()
    begin
        Company.Get();
    end;

    trigger OnPreReport()
    begin
        getReceivedFrom();
    end;

    var
        ReceivedFrom: Text[100];
        CheckReport: Report Check;
        NumberText: array [2] of Text[80];
        AddressLine: Text[250];
        Company: Record "Company Information";
        "G/L Account": Record "G/L Account";
        Customer: Record Customer;
        "Bank Account": Record "Bank Account";
        "Fixed Asset": Record "Fixed Asset";
        Vendor: Record Vendor;
        "IC Partner": Record "IC Partner";
        Photo: Integer;
        Received_with_thanks_fromCaptionLbl: label 'Received with thanks from';
        DateCaptionLbl: label 'Date';
        Cheque_CashCaptionLbl: label 'Cheque/Cash';
        Total_AmountCaptionLbl: label 'Total Amount';
        Amount_in_wordsCaptionLbl: label 'Amount in words';
        Detail_of_receiptCaptionLbl: label 'Detail of receipt';
        Receipt_No_CaptionLbl: label 'Receipt No.';
        Received_by_CaptionLbl: label 'Received by:';


    procedure getReceivedFrom()
    begin
        //check the type of payment being recorded by the user of the system
        if "Gen. Journal Line"."Bal. Account Type"="Gen. Journal Line"."bal. account type"::"G/L Account" then
            begin
                //get the account number from the database using the get method
                "G/L Account".Reset;
                if "G/L Account".Get("Gen. Journal Line"."Bal. Account No.") then
                    begin
                        ReceivedFrom:="G/L Account".Name;
                    end
                else
                    begin
                        ReceivedFrom:='';
                    end;
            end
        else if "Gen. Journal Line"."Bal. Account Type"="Gen. Journal Line"."bal. account type"::Customer then
            begin
                //get the customer name from the database using the get method of the record variable
                Customer.Reset;
                if Customer.Get("Gen. Journal Line"."Bal. Account No.") then
                    begin
                        ReceivedFrom:=Customer.Name;
                    end
                else
                    begin
                        ReceivedFrom:='';
                    end;
            end
        else if "Gen. Journal Line"."Bal. Account Type"="Gen. Journal Line"."bal. account type"::Vendor then
            begin
                //get the vendor name from the database using the get method
                Vendor.Reset;
                if Vendor.Get("Gen. Journal Line"."Bal. Account No.") then
                    begin
                        ReceivedFrom:=Vendor.Name;
                    end
                else
                    begin
                        ReceivedFrom:='';
                    end;
            end
        else if "Gen. Journal Line"."Bal. Account Type"="Gen. Journal Line"."bal. account type"::"Bank Account" then
            begin
                //retrieve the bank account name from the database
                "Bank Account".Reset;
                if "Bank Account".Get("Gen. Journal Line"."Bal. Account No.") then
                    begin
                        ReceivedFrom:="Bank Account".Name;
                    end
                else
                    begin
                        ReceivedFrom:='';
                    end;
            end
        else if "Gen. Journal Line"."Bal. Account Type"="Gen. Journal Line"."bal. account type"::"Fixed Asset" then
            begin
                //get the fixed asset name from the database
                "Fixed Asset".Reset;
                if "Fixed Asset".Get("Gen. Journal Line"."Bal. Account No.") then
                    begin
                        ReceivedFrom:="Fixed Asset".Description;
                    end
                else
                    begin
                        ReceivedFrom:='';
                    end;
            end
        else if "Gen. Journal Line"."Bal. Account Type"="Gen. Journal Line"."bal. account type"::"IC Partner" then
            begin
                //get the name of the ic partner from the database
                "IC Partner".Reset;
                if "IC Partner".Get("Gen. Journal Line"."Bal. Account No.") then
                    begin
                        ReceivedFrom:="IC Partner".Name;
                    end
                else
                    begin
                        ReceivedFrom:='';
                    end;
            end;
    end;
}

