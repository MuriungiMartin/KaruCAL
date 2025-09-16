#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51732 "Account Modification"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Account Modification.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            RequestFilterFields = "No.";
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

            trigger OnAfterGetRecord()
            begin
                DCustL.Reset;
                DCustL.SetRange(DCustL."Customer No.",OldNo);
                if DCustL.Find('-') then begin
                DCustL."Customer No.":=NewNo;
                DCustL.Modify;
                end;
                
                CustL.Reset;
                CustL.SetRange(CustL."Customer No.",OldNo);
                if CustL.Find('-') then begin
                CustL."Customer No.":=NewNo;
                CustL.Modify;
                end;
                
                "CourseReg.".Reset;
                "CourseReg.".SetRange("CourseReg."."Student No.",OldNo);
                if "CourseReg.".Find('-') then begin
                "CourseReg."."Student No.":=NewNo;
                "CourseReg."."Reg. Transacton ID":="CourseReg."."Reg. Transacton ID";
                "CourseReg.".Modify;
                end;
                
                /*
                StudCharges.RESET;
                StudCharges.SETRANGE(StudCharges."Student No.",OldNo);
                IF StudCharges.FIND('-') THEN BEGIN
                StudCharges."Student No.":=NewNo;
                StudCharges.MODIFY;
                END;
                */
                Receipt.Reset;
                Receipt.SetRange(Receipt."Student No.",OldNo);
                if Receipt.Find('-') then begin
                Receipt."Student No.":=NewNo;
                Receipt.Modify;
                end;
                /*
                StudUnits.RESET;
                StudUnits.SETRANGE(StudUnits."Student No.",OldNo);
                IF StudUnits.FIND('-') THEN BEGIN
                StudUnits."Student No.":=NewNo;
                StudUnits.MODIFY;
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
        "CourseReg.": Record UnknownRecord61532;
        CustL: Record "Cust. Ledger Entry";
        DCustL: Record "Detailed Cust. Ledg. Entry";
        StudCharges: Record UnknownRecord61535;
        Receipt: Record UnknownRecord61538;
        StudUnits: Record UnknownRecord61549;
        OldNo: Code[20];
        NewNo: Code[20];
        CustomerCaptionLbl: label 'Customer';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

