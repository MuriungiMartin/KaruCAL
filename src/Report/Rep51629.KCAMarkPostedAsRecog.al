#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51629 "KCA Mark Posted As Recog"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/KCA Mark Posted As Recog.rdlc';

    dataset
    {
        dataitem("Cust. Ledger Entry";"Cust. Ledger Entry")
        {
            DataItemTableView = sorting("Entry No.");
            RequestFilterFields = "Posting Date";
            column(ReportForNavId_8503; 8503)
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
            column(Cust__Ledger_Entry__Entry_No__;"Entry No.")
            {
            }
            column(Cust__Ledger_Entry__Customer_No__;"Customer No.")
            {
            }
            column(Cust__Ledger_Entry__Document_No__;"Document No.")
            {
            }
            column(Cust__Ledger_Entry_Description;Description)
            {
            }
            column(Cust__Ledger_Entry_Amount;Amount)
            {
            }
            column(Cust__Ledger_EntryCaption;Cust__Ledger_EntryCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Entry_No__Caption;FieldCaption("Entry No."))
            {
            }
            column(Cust__Ledger_Entry__Customer_No__Caption;FieldCaption("Customer No."))
            {
            }
            column(Cust__Ledger_Entry__Document_No__Caption;FieldCaption("Document No."))
            {
            }
            column(Cust__Ledger_Entry_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Cust__Ledger_Entry_AmountCaption;FieldCaption(Amount))
            {
            }

            trigger OnAfterGetRecord()
            begin
                if "Cust. Ledger Entry".Amount < 0 then begin
                StudCharges.Reset;
                StudCharges.SetCurrentkey(StudCharges."Transacton ID",StudCharges."Student No.");
                StudCharges.SetRange(StudCharges."Student No.","Cust. Ledger Entry"."Customer No.");
                StudCharges.SetRange(StudCharges."Transacton ID","Cust. Ledger Entry"."Document No.");
                if StudCharges.Find('-') then begin
                StudCharges.Recognized:=true;
                StudCharges.Modify;
                end;

                end else begin
                if Rcpt.Get("Cust. Ledger Entry"."Document No.") then begin
                Rcpt."Un Posted":=true;
                Rcpt.Modify;
                RcptItems.Reset;
                RcptItems.SetCurrentkey(RcptItems."Receipt No");
                RcptItems.SetRange(RcptItems."Receipt No","Cust. Ledger Entry"."Document No.");
                if RcptItems.Find('-') then
                RcptItems.ModifyAll(RcptItems.Posted,true);
                end;

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
        StudCharges: Record UnknownRecord61535;
        Rcpt: Record UnknownRecord61538;
        RcptItems: Record UnknownRecord61539;
        Cust__Ledger_EntryCaptionLbl: label 'Cust. Ledger Entry';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

