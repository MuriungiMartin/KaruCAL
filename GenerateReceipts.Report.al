#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51526 "Generate Receipts"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Generate Receipts.rdlc';

    dataset
    {
        dataitem(UnknownTable61552;UnknownTable61552)
        {
            DataItemTableView = sorting("Transaction Code") where(Posted=const(No));
            RequestFilterFields = Date,"Student No.","Transaction Code";
            column(ReportForNavId_4756; 4756)
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
            column(Imported_Receipts_Buffer__Transaction_Code_;"Transaction Code")
            {
            }
            column(Imported_Receipts_Buffer__Student_No__;"Student No.")
            {
            }
            column(Imported_Receipts_Buffer_Date;Date)
            {
            }
            column(Imported_Receipts_Buffer_Description;Description)
            {
            }
            column(Imported_Receipts_Buffer_Amount;Amount)
            {
            }
            column(Imported_Receipts_Buffer_Posted;Posted)
            {
            }
            column(Imported_Receipts_Buffer_Amount_Control1102760000;Amount)
            {
            }
            column(Imported_Receipts_BufferCaption;Imported_Receipts_BufferCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Imported_Receipts_Buffer__Transaction_Code_Caption;FieldCaption("Transaction Code"))
            {
            }
            column(Imported_Receipts_Buffer__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(Imported_Receipts_Buffer_DateCaption;FieldCaption(Date))
            {
            }
            column(Imported_Receipts_Buffer_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Imported_Receipts_Buffer_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Imported_Receipts_Buffer_PostedCaption;FieldCaption(Posted))
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            var
                Receipt: Record UnknownRecord61538;
            begin
                
                StudentNo:='';
                
                
                if Stud.Get("ACA-Imp. Receipts Buffer"."Student No.") then begin
                StudentNo:=Stud."No.";
                  end else exit;
                /*
                IF StudentNo = '' THEN BEGIN
                Stud.RESET;
                Stud.SETRANGE(Stud."Old Student Code","ACA-Imp. Receipts Buffer"."Student No.");
                IF Stud.FIND('-') THEN
                StudentNo:=Stud."No.";
                
                END;
                
                IF StudentNo = '' THEN BEGIN
                CReg.RESET;
                CReg.SETRANGE(CReg."OLD No.","ACA-Imp. Receipts Buffer"."Student No.");
                IF CReg.FIND('-') THEN
                StudentNo:=CReg."Student No.";
                
                END;
                */
                if StudentNo='' then begin
                  Stud.Reset;
                  Stud.SetRange(Stud."Application No.","ACA-Imp. Receipts Buffer"."Student No.");
                  if Stud.Find('-') then
                     StudentNo:=Stud."No.";
                end;
                //END;
                
                
                if StudentNo = '' then
                StudentNo:="ACA-Imp. Receipts Buffer"."Student No.";
                
                if StudentNo = '' then
                StudentNo:='N/A';
                
                
                
                if Cust.Get(StudentNo) then begin
                if Cust.Blocked=Cust.Blocked::All then begin
                
                //Unallocated Receipts
                /*
                GenJnl.RESET;
                GenJnl.SETRANGE("Journal Template Name",'SALES');
                GenJnl.SETRANGE("Journal Batch Name",'STUD TR');
                GenJnl.DELETEALL;
                */
                
                GenSetup.Get();
                
                LineNo:=LineNo+10000;
                GenJnl.Init;
                GenJnl."Line No." := LineNo;
                GenJnl."Posting Date":="ACA-Imp. Receipts Buffer".Date;
                GenJnl."Document No.":="ACA-Imp. Receipts Buffer"."Transaction Code";
                GenJnl."External Document No.":="ACA-Imp. Receipts Buffer"."Student No.";
                GenJnl.Validate(GenJnl."Document No.");
                GenJnl."Journal Template Name":='SALES';
                GenJnl."Journal Batch Name":='STUD TR';
                GenJnl."Account Type":=GenJnl."account type"::Customer;
                GenJnl."Account No.":=StudentNo;
                GenJnl.Validate(GenJnl."Account No.");
                GenJnl.Amount:="ACA-Imp. Receipts Buffer".Amount;
                GenJnl.Validate(GenJnl.Amount);
                GenJnl.Description:="ACA-Imp. Receipts Buffer".Description;
                //GenJnl."Bal. Account Type":=GenJnl."Bal. Account Type"::"Bank Account";
                //GenJnl."Bal. Account No.":='10';
                if TransType = Transtype::"Direct Bank Deposit" then begin
                GenJnl."Bal. Account Type":=GenJnl."bal. account type"::"Bank Account";
                GenJnl."Bal. Account No.":=TransBank;
                end else if TransType = Transtype::HELB then begin
                GenJnl."Bal. Account Type":=GenJnl."bal. account type"::"G/L Account";
                GenSetup.TestField(GenSetup."Helb Account");
                GenJnl."Bal. Account No.":=GenSetup."Helb Account";
                end else if TransType = Transtype::Bursary then begin
                GenJnl."Bal. Account Type":=GenJnl."bal. account type"::"G/L Account";
                GenSetup.TestField(GenSetup."CDF Account");
                GenJnl."Bal. Account No.":=GenSetup."CDF Account";
                end else if TransType = Transtype::CDF then begin
                GenJnl."Bal. Account Type":=GenJnl."bal. account type"::"G/L Account";
                GenSetup.TestField(GenSetup."CDF Account");
                GenJnl."Bal. Account No.":=GenSetup."CDF Account";
                end else if TransType = Transtype::Prepayment then begin
                GenJnl."Bal. Account Type":=GenJnl."bal. account type"::"G/L Account";
                GenSetup.TestField(GenSetup."Pre-Payment Account");
                GenJnl."Bal. Account No.":=GenSetup."Pre-Payment Account";
                end else if TransType = Transtype::HEF then begin
                GenJnl."Bal. Account Type":=GenJnl."bal. account type"::"G/L Account";
                GenSetup.TestField(GenSetup."HEF Account");
                GenJnl."Bal. Account No.":=GenSetup."HEF Account";
                end;
                GenJnl.Validate(GenJnl."Bal. Account No.");
                if GenJnl.Amount <> 0 then
                GenJnl.Insert;
                
                /*
                GenJnl.SETRANGE("Journal Template Name",'SALES');
                GenJnl.SETRANGE("Journal Batch Name",'STUD TR');
                IF GenJnl.FIND('-') THEN BEGIN
                REPEAT
                GLPosting.RUN(GenJnl);
                UNTIL GenJnl.NEXT = 0;
                END;
                
                GenJnl.RESET;
                GenJnl.SETRANGE("Journal Template Name",'SALES');
                GenJnl.SETRANGE("Journal Batch Name",'STUD TR');
                GenJnl.DELETEALL;
                */
                
                
                "ACA-Imp. Receipts Buffer".Unallocated:=true;
                //"ACA-Imp. Receipts Buffer".Posted:=TRUE;
                "ACA-Imp. Receipts Buffer".Modify;
                
                end else begin
                
                 StudPay.Reset;
                 StudPay.SetRange(StudPay."Student No.",StudentNo);
                 StudPay.SetRange("Cheque No","ACA-Imp. Receipts Buffer"."Transaction Code");
                 if not  StudPay.FindFirst then begin
                
                
                
                StudPay.Init;
                StudPay."Student No.":=StudentNo;
                StudPay."User ID":=UserId;
                //StudPay."Payment Mode":=StudPay."Payment Mode"::"Direct Bank Deposit";
                if TransType = Transtype::"Direct Bank Deposit" then begin
                StudPay."Payment Mode":=StudPay."payment mode"::"Direct Bank Deposit";
                end else if TransType = Transtype::HELB then begin
                StudPay."Payment Mode":=StudPay."payment mode"::HELB;
                end else if TransType = Transtype::Bursary then begin
                StudPay."Payment Mode":=StudPay."payment mode"::CDF;
                end else if TransType = Transtype::CDF then begin
                StudPay."Payment Mode":=StudPay."payment mode"::CDF;
                end else if TransType = Transtype::Prepayment then begin
                StudPay."Payment Mode":=StudPay."payment mode"::Prepayment;
                end else if TransType = Transtype::HEF then begin
                StudPay."Payment Mode":=StudPay."payment mode"::HEF;
                end;
                StudPay."Cheque No":="ACA-Imp. Receipts Buffer"."Transaction Code";
                StudPay."Drawer Name":="ACA-Imp. Receipts Buffer".Description;
                StudPay."Payment By":="ACA-Imp. Receipts Buffer".Description;
                StudPay."Bank No.":=TransBank;
                StudPay."Amount to pay":="ACA-Imp. Receipts Buffer".Amount;
                
                StudPay.Validate(StudPay."Amount to pay");
                StudPay."Transaction Date":="ACA-Imp. Receipts Buffer".Date;
                //StudPay.VALIDATE(StudPay."Auto Bill");
                StudPay.Validate(StudPay."Auto Post Final");
                
                StudPay.Insert;
                end else begin
                Receipt.Reset;
                Receipt.SetRange("Bank Slip/Cheque No",StudPay."Cheque No");
                if not Receipt.FindFirst then
                StudPay.Validate(StudPay."Auto Post Final");
                end;
                /*
                GenSetup.GET();
                
                LineNo:=LineNo+10000;
                GenJnl.INIT;
                GenJnl."Line No." := LineNo;
                GenJnl."Posting Date":="ACA-Imp. Receipts Buffer".Date;
                GenJnl."Document No.":="ACA-Imp. Receipts Buffer"."Transaction Code";
                GenJnl."External Document No.":="ACA-Imp. Receipts Buffer"."Student No.";
                GenJnl.VALIDATE(GenJnl."Document No.");
                GenJnl."Journal Template Name":='SALES';
                GenJnl."Journal Batch Name":='STUD TR';
                GenJnl."Account Type":=GenJnl."Account Type"::Customer;
                GenJnl."Account No.":=StudentNo;//GenSetup."Unallocated Rcpts Account";
                GenJnl.VALIDATE(GenJnl."Account No.");
                GenJnl.Amount:="ACA-Imp. Receipts Buffer".Amount * -1;
                GenJnl.VALIDATE(GenJnl.Amount);
                GenJnl.Description:="ACA-Imp. Receipts Buffer".Description;
                //GenJnl."Bal. Account Type":=GenJnl."Bal. Account Type"::"Bank Account";
                //GenJnl."Bal. Account No.":='10';
                IF TransType = TransType::"Direct Bank Deposit" THEN BEGIN
                GenJnl."Bal. Account Type":=GenJnl."Bal. Account Type"::"Bank Account";
                GenJnl."Bal. Account No.":=TransBank;
                END ELSE IF TransType = TransType::HELB THEN BEGIN
                GenJnl."Bal. Account Type":=GenJnl."Bal. Account Type"::"G/L Account";
                GenSetup.TESTFIELD(GenSetup."Helb Account");
                GenJnl."Bal. Account No.":=GenSetup."Helb Account";
                END ELSE IF TransType = TransType::Bursary THEN BEGIN
                GenJnl."Bal. Account Type":=GenJnl."Bal. Account Type"::"G/L Account";
                GenSetup.TESTFIELD(GenSetup."CDF Account");
                GenJnl."Bal. Account No.":=GenSetup."CDF Account";
                END ELSE IF TransType = TransType::CDF THEN BEGIN
                GenJnl."Bal. Account Type":=GenJnl."Bal. Account Type"::"G/L Account";
                GenSetup.TESTFIELD(GenSetup."CDF Account");
                GenJnl."Bal. Account No.":=GenSetup."CDF Account";
                END;
                GenJnl.VALIDATE(GenJnl."Bal. Account No.");
                IF GenJnl.Amount <> 0 THEN
                GenJnl.INSERT;
                
                */
                "ACA-Imp. Receipts Buffer".Unallocated:=true;
                "ACA-Imp. Receipts Buffer".Posted:=true;
                "ACA-Imp. Receipts Buffer".Modify;
                end;
                
                end else begin
                //Unallocated Receipts
                /*
                GenJnl.RESET;
                GenJnl.SETRANGE("Journal Template Name",'SALES');
                GenJnl.SETRANGE("Journal Batch Name",'STUD TR');
                GenJnl.DELETEALL;
                */
                
                GenSetup.Get();
                
                LineNo:=LineNo+10000;
                GenJnl.Init;
                GenJnl."Line No." := LineNo;
                GenJnl."Posting Date":="ACA-Imp. Receipts Buffer".Date;
                GenJnl."Document No.":="ACA-Imp. Receipts Buffer"."Transaction Code";
                GenJnl."External Document No.":="ACA-Imp. Receipts Buffer"."Student No.";
                GenJnl.Validate(GenJnl."Document No.");
                GenJnl."Journal Template Name":='SALES';
                GenJnl."Journal Batch Name":='STUD TR';
                GenJnl."Account Type":=GenJnl."account type"::Customer;
                GenJnl."Account No.":=GenSetup."Unallocated Rcpts Account";
                GenJnl.Validate(GenJnl."Account No.");
                GenJnl.Amount:="ACA-Imp. Receipts Buffer".Amount * -1;
                GenJnl.Validate(GenJnl.Amount);
                GenJnl.Description:="ACA-Imp. Receipts Buffer".Description;
                //GenJnl."Bal. Account Type":=GenJnl."Bal. Account Type"::"Bank Account";
                //GenJnl."Bal. Account No.":='10';
                if TransType = Transtype::"Direct Bank Deposit" then begin
                GenJnl."Bal. Account Type":=GenJnl."bal. account type"::"Bank Account";
                GenJnl."Bal. Account No.":=TransBank;
                end else if TransType = Transtype::HELB then begin
                GenJnl."Bal. Account Type":=GenJnl."bal. account type"::"G/L Account";
                GenSetup.TestField(GenSetup."Helb Account");
                GenJnl."Bal. Account No.":=GenSetup."Helb Account";
                end else if TransType = Transtype::Bursary then begin
                GenJnl."Bal. Account Type":=GenJnl."bal. account type"::"G/L Account";
                GenSetup.TestField(GenSetup."CDF Account");
                GenJnl."Bal. Account No.":=GenSetup."CDF Account";
                end else if TransType = Transtype::CDF then begin
                GenJnl."Bal. Account Type":=GenJnl."bal. account type"::"G/L Account";
                GenSetup.TestField(GenSetup."CDF Account");
                GenJnl."Bal. Account No.":=GenSetup."CDF Account";
                end else if TransType = Transtype::HEF then begin
                GenJnl."Bal. Account Type":=GenJnl."bal. account type"::"G/L Account";
                GenSetup.TestField(GenSetup."HEF Account");
                GenJnl."Bal. Account No.":=GenSetup."HEF Account";
                end;
                GenJnl.Validate(GenJnl."Bal. Account No.");
                if GenJnl.Amount <> 0 then
                GenJnl.Insert;
                
                
                "ACA-Imp. Receipts Buffer".Unallocated:=true;
                //"ACA-Imp. Receipts Buffer".Posted:=TRUE;
                "ACA-Imp. Receipts Buffer".Modify;
                
                end;
                //END;

            end;

            trigger OnPostDataItem()
            begin
                
                
                GenJnl.SetRange("Journal Template Name",'SALES');
                GenJnl.SetRange("Journal Batch Name",'STUD TR');
                if GenJnl.Find('-') then begin
                repeat
                //GLPosting.RUN(GenJnl);
                until GenJnl.Next = 0;
                end;
                /*
                GenJnl.RESET;
                GenJnl.SETRANGE("Journal Template Name",'SALES');
                GenJnl.SETRANGE("Journal Batch Name",'STUD TR');
                GenJnl.DELETEALL;
                */

            end;

            trigger OnPreDataItem()
            begin

                if TransType = Transtype::" " then
                Error('You must specify the trasaction type.');


                LineNo:=0;
                GenJnl.Reset;
                GenJnl.SetRange("Journal Template Name",'SALES');
                GenJnl.SetRange("Journal Batch Name",'STUD TR');
                GenJnl.DeleteAll;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(TransType;TransType)
                {
                    ApplicationArea = Basic;
                    Caption = 'Transaction Type';
                }
                field(TransBank;TransBank)
                {
                    ApplicationArea = Basic;
                    Caption = 'Transaction Bank';
                    TableRelation = "Bank Account";
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        StudPay: Record UnknownRecord61536;
        Cust: Record Customer;
        GenJnl: Record "Gen. Journal Line";
        GenSetup: Record UnknownRecord61534;
        GLPosting: Codeunit "Gen. Jnl.-Post Line";
        Stud: Record Customer;
        StudentNo: Code[20];
        CReg: Record UnknownRecord61532;
        LineNo: Integer;
        TransType: Option " ","Direct Bank Deposit",HELB,Bursary,CDF,Prepayment,HEF;
        Imported_Receipts_BufferCaptionLbl: label 'Imported Receipts Buffer';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        TotalCaptionLbl: label 'Total';
        TransBank: Code[20];
}

