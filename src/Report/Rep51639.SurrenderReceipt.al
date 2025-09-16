#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51639 "Surrender Receipt"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Surrender Receipt.rdlc';

    dataset
    {
        dataitem("Imprest Surrender Header";UnknownTable61504)
        {
            DataItemTableView = where(Posted=const(Yes));
            column(ReportForNavId_8431; 8431)
            {
            }
            column(RecNo;RecNo)
            {
            }
            column(Imprest_Surrender_Header__Surrender_Date_;"Surrender Date")
            {
            }
            column(Imprest_Surrender_Header__Imprest_Surrender_Header___Account_Name_;"Imprest Surrender Header"."Account Name")
            {
            }
            column(Imprest_Surrender_Header__Time_Posted_;"Time Posted")
            {
            }
            column(Imprest_Surrender_Header_No;No)
            {
            }
            dataitem(UnknownTable61733;UnknownTable61733)
            {
                DataItemLink = "Surrender Doc No."=field(No);
                column(ReportForNavId_9509; 9509)
                {
                }
                column(Imprest_Surrender_Details__Cash_Surrender_Amt_;"Cash Surrender Amt")
                {
                }
                column(Imprest_Surrender_Details__Account_Name_;"Account Name")
                {
                }
                column(Imprest_Surrender_Details_Surrender_Doc_No_;"Surrender Doc No.")
                {
                }
                column(Imprest_Surrender_Details_Account_No_;"Account No:")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    /*DimValues.RESET;
                    DimValues.SETRANGE(DimValues."Dimension Code",'BRANCHES');
                    DimValues.SETRANGE(DimValues.Code,"Receipt Line q"."Branch Code");
                    
                    IF DimValues.FIND('-') THEN BEGIN
                    CompName:=DimValues.Name;
                    END
                    ELSE BEGIN
                    CompName:='';
                    END;
                    */
                    /*
                    Banks.RESET;
                    Banks.SETRANGE(Banks.Code,"Receipt Test Line"."Bank Code");
                    IF Banks.FIND('-') THEN BEGIN
                    BankName:=Banks.Description;
                    END
                    ELSE BEGIN
                    BankName:='';
                    END;
                    */
                    //CheckReport.FormatNoText(NumberText,Receipts.Amount,'');
                    //
                    
                    TotalAmount:=TotalAmount + Amount;
                    //VatAmount:=VatAmount + "VAT Amount";
                    
                    RecPayTypes.Reset;
                    RecPayTypes.SetRange(RecPayTypes.Type,RecPayTypes.Type::Receipt);
                    //RecPayTypes.SETRANGE(RecPayTypes.Code,"Receipt Line q".Type);
                    if RecPayTypes.FindFirst then
                      begin
                        TypeName:=RecPayTypes.Description;
                      end;
                    "Account Name":='Cash Surrendered Amount';

                end;
            }
            dataitem("Integer";"Integer")
            {
                DataItemTableView = sorting(Number) order(ascending) where(Number=const(1));
                column(ReportForNavId_5444; 5444)
                {
                }
                column(NumberText_1_;NumberText[1])
                {
                }
                column(Imprest_Surrender_Header__Cashier;"Imprest Surrender Header".Cashier)
                {
                }
                column(Imprest_Surrender_Details___Cash_Surrender_Amt_;"FIN-Imprest Surrender Details"."Cash Surrender Amt")
                {
                }
                column(Integer_Number;Number)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                StrCopyText:='';
                StrInvoices:='';
                if "No. Printed">=1 then
                  begin
                    StrCopyText:='DUPLICATE';
                  end;
                TotalAmount:=0;VatAmount:=0;
                //Amount into words
                "Imprest Surrender Header".CalcFields("Cash Surrender Amt");
                CheckReport.InitTextVariable;
                CheckReport.FormatNoText(NumberText,"Cash Surrender Amt",'');
                "Imprest Surrender Header"."Print No.":="Imprest Surrender Header"."Print No." + 1;
                Modify;
                if "Imprest Surrender Header"."Print No.">1 then
                  begin
                    Msg:='[DUPLICATE] COPY NO:' + Format("Imprest Surrender Header"."Print No.");
                  end;

                //Set the currency code
                CurrCode:="Currency Code";

                if CurrCode='' then
                  begin
                    //get the lcy code from the general ledger setup
                    GLSetup.Reset;
                    GLSetup.Get();
                    CurrCode:=GLSetup."LCY Code";
                  end;
                DimValues.Reset;
                DimValues.SetRange(DimValues."Dimension Code",'BUDGET CENTRE');
                DimValues.SetRange(DimValues.Code,"Imprest Surrender Header"."Global Dimension 2 Code");
                if DimValues.FindFirst then
                  begin
                    DimName:=DimValues.Name;
                  end;

                //get the details of the account from the database
                Appl.Reset;
                Appl.SetRange(Appl."Document Type",Appl."document type"::Receipt);
                Appl.SetRange(Appl."Document No.","Imprest Surrender Header".No);
                if Appl.FindFirst then
                  begin
                    repeat
                      StrInvoices:=StrInvoices + '::'+ Appl."Appl. Doc. No";
                    until Appl.Next=0;
                  end;
                StrInvoices:=CopyStr('Invoices Paid:' + StrInvoices,1,250);
                ReceiptHeader.Reset;
                ReceiptHeader.SetRange(ReceiptHeader."Surrender No","Imprest Surrender Header".No);
                if ReceiptHeader.Find('-') then begin
                RecNo:=ReceiptHeader."No.";
                end;
            end;

            trigger OnPostDataItem()
            begin
                if CurrReport.Preview=false then
                  begin
                    "No. Printed":="No. Printed"+1;
                    Modify;
                  end;
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
        StrInvoices: Text[250];
        DimValues: Record "Dimension Value";
        CompName: Text[100];
        TypeOfDoc: Text[100];
        RecPayTypes: Record UnknownRecord61129;
        BankName: Text[100];
        NumberText: array [2] of Text[120];
        CheckReport: Report Check;
        TotalAmount: Decimal;
        VatAmount: Decimal;
        Msg: Text[60];
        CurrCode: Code[20];
        GLSetup: Record "General Ledger Setup";
        TypeName: Text[60];
        DimName: Text[60];
        StrCopyText: Text[60];
        Appl: Record UnknownRecord61728;
        RecNo: Code[20];
        ReceiptHeader: Record UnknownRecord61723;
}

