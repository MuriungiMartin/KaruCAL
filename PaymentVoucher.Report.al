#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51662 "Payment Voucher"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Payment Voucher.rdlc';
    EnableExternalImages = true;

    dataset
    {
        dataitem(UnknownTable61688;UnknownTable61688)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(ReportForNavId_6437; 6437)
            {
            }
            column(DOCNAME;DOCNAME)
            {
            }
            column(Payments_Header__Payments_Header___No__;"Payments Header"."No.")
            {
            }
            column(Payments_Header__Cheque_No__;"Cheque No.")
            {
            }
            column(Payments_Header_Payee;Payee)
            {
            }
            column(Payments_Header__Payments_Header__Date;"Payments Header".Date)
            {
            }
            column(Payments_Header__Global_Dimension_1_Code_;"Global Dimension 1 Code")
            {
            }
            column(Payments_Header__Budget_Center_Name_;"Budget Center Name")
            {
            }
            column(Paying_Bank_Account________Bank_Name_;"Paying Bank Account"+': '+"Bank Name")
            {
            }
            column(Payments_Header__Payments_Header___Reference_No__;"Payments Header"."Reference No.")
            {
            }
            column(Payments_Header__Imprest_No__;"Imprest No.")
            {
            }
            column(Payments_Header__Payments_Header___Payment_Narration_;"Payments Header"."Payment Narration")
            {
            }
            column(USERID;UserId)
            {
            }
            column(NumberText_1_;NumberText[1])
            {
            }
            column(TTotal;TTotal)
            {
            }
            column(TIME_PRINTED_____FORMAT_TIME_;'TIME PRINTED:' + Format(Time))
            {
                AutoFormatType = 1;
            }
            column(DATE_PRINTED_____FORMAT_TODAY_0_4_;'DATE PRINTED:' + Format(Today,0,4))
            {
                AutoFormatType = 1;
            }
            column(CurrCode;CurrCode)
            {
            }
            column(CurrCode_Control1102756012;CurrCode)
            {
            }
            column(USERID_Control1102755005;UserId)
            {
            }
            column(KARATINA_UNIVERSITYSCaption;KARATINA_UNIVERSITYSCaptionLbl)
            {
            }
            column(PAYMENT_DETAILSCaption;PAYMENT_DETAILSCaptionLbl)
            {
            }
            column(AMOUNTCaption;AMOUNTCaptionLbl)
            {
            }
            column(NET_AMOUNTCaption;NET_AMOUNTCaptionLbl)
            {
            }
            column(W_TAXCaption;W_TAXCaptionLbl)
            {
            }
            column(Document_No___Caption;Document_No___CaptionLbl)
            {
            }
            column(Payment_To_Caption;Payment_To_CaptionLbl)
            {
            }
            column(Document_Date_Caption;Document_Date_CaptionLbl)
            {
            }
            column(Cheque_No__Caption;Cheque_No__CaptionLbl)
            {
            }
            column(Payments_Header__Global_Dimension_1_Code_Caption;FieldCaption("Global Dimension 1 Code"))
            {
            }
            column(Department_NameCaption;Department_NameCaptionLbl)
            {
            }
            column(Paying_Bank_AccountCaption;Paying_Bank_AccountCaptionLbl)
            {
            }
            column(P_A_Y_ECaption;P_A_Y_ECaptionLbl)
            {
            }
            column(Payment_Voucher_No___Caption;Payment_Voucher_No___CaptionLbl)
            {
            }
            column(Payments_Header__Imprest_No__Caption;FieldCaption("Imprest No."))
            {
            }
            column(Payment_NarrationCaption;Payment_NarrationCaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            column(Printed_By_Caption;Printed_By_CaptionLbl)
            {
            }
            column(Amount_in_wordsCaption;Amount_in_wordsCaptionLbl)
            {
            }
            column(ApprovalsCaption;ApprovalsCaptionLbl)
            {
            }
            column(SignatureCaption;SignatureCaptionLbl)
            {
            }
            column(Date_____________________________________Caption;Date_____________________________________CaptionLbl)
            {
            }
            column(EmptyStringCaption;EmptyStringCaptionLbl)
            {
            }
            column(Internal_Audit_______________________________Caption;Internal_Audit_______________________________CaptionLbl)
            {
            }
            column(SignatureCaption_Control1102755037;SignatureCaption_Control1102755037Lbl)
            {
            }
            column(Date____________________________________________Caption;Date____________________________________________CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1102755040;EmptyStringCaption_Control1102755040Lbl)
            {
            }
            column(Authorized_By____________________________Caption;Authorized_By____________________________CaptionLbl)
            {
            }
            column(SignatureCaption_Control1102755043;SignatureCaption_Control1102755043Lbl)
            {
            }
            column(Date________________________Caption;Date________________________CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1102755045;EmptyStringCaption_Control1102755045Lbl)
            {
            }
            column(Examined_By___________________________Caption;Examined_By___________________________CaptionLbl)
            {
            }
            column(Date_________________________________________Caption;Date_________________________________________CaptionLbl)
            {
            }
            column(SignatureCaption_Control1102755061;SignatureCaption_Control1102755061Lbl)
            {
            }
            column(Date______________________________________Caption;Date______________________________________CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1102755063;EmptyStringCaption_Control1102755063Lbl)
            {
            }
            column(Checked_By____________________________Caption;Checked_By____________________________CaptionLbl)
            {
            }
            column(SignatureCaption_Control1102755065;SignatureCaption_Control1102755065Lbl)
            {
            }
            column(EmptyStringCaption_Control1102755066;EmptyStringCaption_Control1102755066Lbl)
            {
            }
            column(SignatureCaption_Control1102755067;SignatureCaption_Control1102755067Lbl)
            {
            }
            column(Prepared_By_Caption;Prepared_By_CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1102755069;EmptyStringCaption_Control1102755069Lbl)
            {
            }
            column(Date_____________________________________Caption_Control1102755070;Date_____________________________________Caption_Control1102755070Lbl)
            {
            }
            column(Votebook_Control________________________________________Caption;Votebook_Control________________________________________CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1102755015;EmptyStringCaption_Control1102755015Lbl)
            {
            }
            dataitem(UnknownTable61705;UnknownTable61705)
            {
                DataItemLink = No=field("No.");
                DataItemTableView = sorting("Line No.",No,Type) order(ascending);
                column(ReportForNavId_3474; 3474)
                {
                }
                column(Payment_Line__Net_Amount__;"Net Amount" )
                {
                }
                column(Payment_Line_Amount;Amount)
                {
                }
                column(Account_No________Account_Name_;"Account No."+':'+"Account Name")
                {
                }
                column(Payment_Line__Withholding_Tax_Amount_;"Withholding Tax Amount")
                {
                }
                column(Payment_Line__PAYE_Amount_;"PAYE Amount")
                {
                }
                column(Payment_Line_Line_No_;"Line No.")
                {
                }
                column(Payment_Line_No;No)
                {
                }
                column(Payment_Line_Type;Type)
                {
                }
                column(Payment_Line_Account_No_;"Account No.")
                {
                }
                column(VATWithheldAmount_PaymentLine;"Payment Line"."VAT Withheld Amount")
                {
                }
                column(PAYEAmount_PaymentLine;"Payment Line"."PAYE Amount")
                {
                }
                column(RetentionAmount_PaymentLine;"Payment Line"."Retention  Amount")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if "Payment Line".Find('-') then begin
                    "Control-Inf.".CalcFields(Picture);
                    end;

                    DimVal.Reset;
                    DimVal.SetRange(DimVal."Dimension Code",'DEPARTMENT');
                    DimVal.SetRange(DimVal.Code,"Shortcut Dimension 2 Code");
                    DimValName:='';
                    if DimVal.FindFirst then
                      begin
                        DimValName:=DimVal.Name;
                      end;

                    TTotal:=TTotal + "Payment Line"."Net Amount" ;
                    "Payment Line"."Account Name":=UpperCase("Payment Line"."Account Name");
                    // MESSAGE('TTOTAL=',FORMAT("Payment Line"."Net Amount"));

                    CheckReport.InitTextVariable();
                    CheckReport.FormatNoText(NumberText,TTotal,'');
                end;
            }
            dataitem(Total;"Integer")
            {
                DataItemTableView = sorting(Number) order(ascending) where(Number=const(1));
                column(ReportForNavId_3476; 3476)
                {
                }
            }
            dataitem(Summary;UnknownTable61705)
            {
                DataItemLink = No=field("No.");
                DataItemTableView = sorting("Line No.",No,Type) order(ascending);
                column(ReportForNavId_3570; 3570)
                {
                }
                column(Summary_Line_No_;"Line No.")
                {
                }
                column(Summary_No;No)
                {
                }
                column(Summary_Type;Type)
                {
                }
                column(Summary_Account_No_;"Account No.")
                {
                }
                dataitem("Vendor Ledger Entry";"Vendor Ledger Entry")
                {
                    DataItemLink = "Vendor No."=field("Account No."),"Applies-to ID"=field(No);
                    column(ReportForNavId_4114; 4114)
                    {
                    }
                    column(Vendor_Ledger_Entry__Document_No__;"Document No.")
                    {
                    }
                    column(Vendor_Ledger_Entry__External_Document_No__;"External Document No.")
                    {
                    }
                    column(Vendor_Ledger_Entry_Description;Description)
                    {
                    }
                    column(Vendor_Ledger_Entry__Amount_to_Apply_;"Amount to Apply")
                    {
                    }
                    column(Vendor_Ledger_Entry__Document_No__Caption;FieldCaption("Document No."))
                    {
                    }
                    column(Vendor_Ledger_Entry__External_Document_No__Caption;FieldCaption("External Document No."))
                    {
                    }
                    column(Vendor_Ledger_Entry_DescriptionCaption;FieldCaption(Description))
                    {
                    }
                    column(Vendor_Ledger_Entry__Amount_to_Apply_Caption;FieldCaption("Amount to Apply"))
                    {
                    }
                    column(Summary_of_Invoices_PaidCaption;Summary_of_Invoices_PaidCaptionLbl)
                    {
                    }
                    column(Vendor_Ledger_Entry_Entry_No_;"Entry No.")
                    {
                    }
                    column(Vendor_Ledger_Entry_Vendor_No_;"Vendor No.")
                    {
                    }
                    column(Vendor_Ledger_Entry_Applies_to_ID;"Applies-to ID")
                    {
                    }
                    column(OrderNo;"Vendor Ledger Entry"."Order No")
                    {
                    }
                    column(VDate;"Vendor Ledger Entry"."Posting Date")
                    {
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    DimVal.Reset;
                    DimVal.SetRange(DimVal."Dimension Code",'DEPARTMENT');
                    DimVal.SetRange(DimVal.Code,"Shortcut Dimension 2 Code");
                    DimValName:='';
                    if DimVal.FindFirst then
                      begin
                        DimValName:=DimVal.Name;
                      end;

                    STotal:=STotal + "Net Amount";
                    //MESSAGE('TTOTAL=',FORMAT("Payment Line"."Net Amount"));
                end;
            }
            dataitem("Integer";"Integer")
            {
                DataItemTableView = sorting(Number) order(ascending) where(Number=const(1));
                column(ReportForNavId_5444; 5444)
                {
                }
            }
            dataitem(UnknownTable61728;UnknownTable61728)
            {
                DataItemLink = "Document No."=field("No.");
                DataItemTableView = sorting("Line Number") order(ascending) where("Document Type"=const(PV));
                column(ReportForNavId_1937; 1937)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                /*Signat.RESET;
                Signat.SETRANGE(Signat."User ID","Payments Header".Cashier);
                IF Signat.FIND('-') THEN BEGIN
                  Signat.CALCFIELDS(Signat."User Signature");
                END;
                
                counts:=0;
                counting:=0;
                signature1.RESET;
                signature1.SETRANGE(signature1."Document Number","Payments Header""."No.");
                signature1.SETFILTER(signature1."Approval Code",'%1|%2','P-VOUCHER','PETTY');
                
                IF signature1.FIND('-') THEN BEGIN
                  signature1.CALCFIELDS(signature1."Approver Signature");
                
                signature2.RESET;
                signature2.SETRANGE(signature2."Document Number","Payments Header""."No.");
                signature2.SETFILTER(signature2."Approval Code",'%1|%2','P-VOUCHER','PETTY');
                signature2.SETFILTER(signature2."Line No",'<>%1',signature1."Line No");
                IF signature2.FIND('-') THEN BEGIN
                  signature2.CALCFIELDS(signature2."Approver Signature");
                END;
                
                
                signature3.RESET;
                signature3.SETRANGE(signature3."Document Number","Payments Header""."No.");
                signature3.SETFILTER(signature3."Approval Code",'%1|%2','P-VOUCHER','PETTY');
                signature3.SETFILTER(signature3."Line No",'<>%1 & <>%2',signature1."Line No",signature2."Line No");
                IF signature3.FIND('-') THEN BEGIN
                  signature3.CALCFIELDS(signature3."Approver Signature");
                END;
                
                
                signature4.RESET;
                signature4.SETRANGE(signature4."Document Number","Payments Header""."No.");
                signature4.SETFILTER(signature4."Approval Code",'%1|%2','P-VOUCHER','PETTY');
                signature4.SETFILTER(signature4."Line No",'<>%1 & <>%2 & <>%3',signature1."Line No",signature2."Line No",signature3."Line No");
                IF signature4.FIND('-') THEN BEGIN
                  signature4.CALCFIELDS(signature4."Approver Signature");
                END;
                
                END;
                 */
                
                
                if "Payments Header".Find('-') then begin
                "Control-Inf.".CalcFields(Picture);
                  end;
                
                
                StrCopyText:='';
                if "No. Printed">=1 then
                  begin
                    StrCopyText:='DUPLICATE';
                  end;
                TTotal:=0;
                
                if "Payments Header"."Payment Type"="Payments Header"."payment type"::Normal then
                 DOCNAME:='PAYMENT VOUCHER'
                  else
                    DOCNAME:='PETTY CASH VOUCHER';
                
                //Set currcode to Default if blank
                GLSetup.Get();
                if "Payments Header"."Currency Code"='' then begin
                  CurrCode:=GLSetup."LCY Code";
                end else
                  CurrCode:="Payments Header"."Currency Code";
                
                //For Inv Curr Code
                if "Payments Header"."Invoice Currency Code"='' then begin
                  InvoiceCurrCode:=GLSetup."LCY Code";
                end else
                  InvoiceCurrCode:="Payments Header"."Invoice Currency Code";
                
                //End;
                
                ApprovalEntry.Reset;
                ApprovalEntry.SetRange(ApprovalEntry."Document No.","Payments Header"."No.");
                //ApprovalEntry.SETRANGE(ApprovalEntry."Document Type",7);
                if ApprovalEntry.Find('-') then repeat
                  ApprovalUserArr[ApprovalEntry."Sequence No."]:=ApprovalEntry."Approver ID";
                  ApprovalDateArr[ApprovalEntry."Sequence No."]:=ApprovalEntry."Last Date-Time Modified";
                until ApprovalEntry.Next=0;
                "Payments Header".Payee:=UpperCase("Payments Header".Payee);

            end;

            trigger OnPostDataItem()
            begin
                if CurrReport.Preview=false then
                  begin
                    "No. Printed":="No. Printed" + 1;
                    Modify;
                  end;
            end;

            trigger OnPreDataItem()
            begin

                LastFieldNo := FieldNo("Payments Header"."No.");
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
        StrCopyText: Text[30];
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        DimVal: Record "Dimension Value";
        DimValName: Text[150];
        TTotal: Decimal;
        CheckReport: Report Check;
        NumberText: array [2] of Text[100];
        STotal: Decimal;
        InvoiceCurrCode: Code[10];
        CurrCode: Code[10];
        GLSetup: Record "General Ledger Setup";
        DOCNAME: Text[30];
        ApprovalEntry: Record "Approval Entry";
        ApprovalUserArr: array [10] of Code[30];
        ApprovalDateArr: array [10] of DateTime;
        "Control-Inf.": Record UnknownRecord61119;
        SignaturePool: Record UnknownRecord61085;
        signature1: Record UnknownRecord61085;
        signature2: Record UnknownRecord61085;
        signature3: Record UnknownRecord61085;
        signature4: Record UnknownRecord61085;
        countraws: Integer;
        counts: Integer;
        Signatures: array [3,2] of InStream;
        addre: array [3,2] of Text[50];
        addreApprover: array [3,2] of Text[50];
        addreDate: array [3,2] of Date;
        usesed: Code[10];
        usese: Code[10];
        counting: Integer;
        ApprovTemplate: Record UnknownRecord464;
        ApprovEntry: Record "Approval Entry";
        Signat: Record "User Setup";
        KARATINA_UNIVERSITYSCaptionLbl: label 'KARATINA UNIVERSITY';
        PAYMENT_DETAILSCaptionLbl: label 'PAYMENT DETAILS';
        AMOUNTCaptionLbl: label 'AMOUNT';
        NET_AMOUNTCaptionLbl: label 'NET AMOUNT';
        W_TAXCaptionLbl: label 'W/TAX';
        Document_No___CaptionLbl: label 'Document No. :';
        Payment_To_CaptionLbl: label 'Payment To:';
        Document_Date_CaptionLbl: label 'Document Date:';
        Cheque_No__CaptionLbl: label 'Cheque No.:';
        Department_NameCaptionLbl: label 'Department Name';
        Paying_Bank_AccountCaptionLbl: label 'Paying Bank Account';
        P_A_Y_ECaptionLbl: label 'P.A.Y.E';
        Payment_Voucher_No___CaptionLbl: label 'Payment Voucher No. :';
        Payment_NarrationCaptionLbl: label 'Payment Narration';
        TotalCaptionLbl: label 'Total';
        Printed_By_CaptionLbl: label 'Printed By:';
        Amount_in_wordsCaptionLbl: label 'Amount in words';
        ApprovalsCaptionLbl: label 'Approvals';
        SignatureCaptionLbl: label 'Signature';
        Date_____________________________________CaptionLbl: label 'Date:....................................';
        EmptyStringCaptionLbl: label '....................................................';
        Internal_Audit_______________________________CaptionLbl: label 'Internal Audit:..............................';
        SignatureCaption_Control1102755037Lbl: label 'Signature';
        Date____________________________________________CaptionLbl: label 'Date:...........................................';
        EmptyStringCaption_Control1102755040Lbl: label '............................................';
        Authorized_By____________________________CaptionLbl: label 'Authorized By:...........................';
        SignatureCaption_Control1102755043Lbl: label 'Signature';
        Date________________________CaptionLbl: label 'Date:_______________________';
        EmptyStringCaption_Control1102755045Lbl: label '______________________________';
        Examined_By___________________________CaptionLbl: label 'Examined By:..........................';
        Date_________________________________________CaptionLbl: label 'Date:........................................';
        SignatureCaption_Control1102755061Lbl: label 'Signature';
        Date______________________________________CaptionLbl: label 'Date:.....................................';
        EmptyStringCaption_Control1102755063Lbl: label '............................................';
        Checked_By____________________________CaptionLbl: label 'Checked By:...........................';
        SignatureCaption_Control1102755065Lbl: label 'Signature';
        EmptyStringCaption_Control1102755066Lbl: label '.........................................';
        SignatureCaption_Control1102755067Lbl: label 'Signature';
        Prepared_By_CaptionLbl: label 'Prepared By:';
        EmptyStringCaption_Control1102755069Lbl: label '.....................................';
        Date_____________________________________Caption_Control1102755070Lbl: label 'Date:....................................';
        Votebook_Control________________________________________CaptionLbl: label 'Votebook Control:.......................................';
        EmptyStringCaption_Control1102755015Lbl: label '...............................';
        Summary_of_Invoices_PaidCaptionLbl: label 'Summary of Invoices Paid';
}

