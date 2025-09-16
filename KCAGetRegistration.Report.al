#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51605 "KCA Get Registration"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/KCA Get Registration.rdlc';

    dataset
    {
        dataitem(UnknownTable61539;UnknownTable61539)
        {
            DataItemTableView = sorting("Receipt No");
            RequestFilterFields = "Receipt No",Description,Date;
            column(ReportForNavId_9528; 9528)
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
            column(Receipt_Items__Receipt_No_;"Receipt No")
            {
            }
            column(Receipt_Items_Code;Code)
            {
            }
            column(Receipt_Items_Description;Description)
            {
            }
            column(Receipt_Items_Amount;Amount)
            {
            }
            column(Receipt_Items_Balance;Balance)
            {
            }
            column(Receipt_Items_Date;Date)
            {
            }
            column(Receipt_Items_Programme;Programme)
            {
            }
            column(Receipt_Items_Stage;Stage)
            {
            }
            column(Receipt_Items_Unit;Unit)
            {
            }
            column(Receipt_Items_Semester;Semester)
            {
            }
            column(Receipt_Items__Settlement_Type_;"Settlement Type")
            {
            }
            column(Receipt_ItemsCaption;Receipt_ItemsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Receipt_Items__Receipt_No_Caption;FieldCaption("Receipt No"))
            {
            }
            column(Receipt_Items_CodeCaption;FieldCaption(Code))
            {
            }
            column(Receipt_Items_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Receipt_Items_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Receipt_Items_BalanceCaption;FieldCaption(Balance))
            {
            }
            column(Receipt_Items_DateCaption;FieldCaption(Date))
            {
            }
            column(Receipt_Items_ProgrammeCaption;FieldCaption(Programme))
            {
            }
            column(Receipt_Items_StageCaption;FieldCaption(Stage))
            {
            }
            column(Receipt_Items_UnitCaption;FieldCaption(Unit))
            {
            }
            column(Receipt_Items_SemesterCaption;FieldCaption(Semester))
            {
            }
            column(Receipt_Items__Settlement_Type_Caption;FieldCaption("Settlement Type"))
            {
            }
            column(Receipt_Items_Uniq_No_2;"Uniq No 2")
            {
            }
            column(Receipt_Items_Transaction_ID;"Transaction ID")
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Rcpt.Get("ACA-Receipt Items"."Receipt No") then begin
                StudCharges.SetCurrentkey(StudCharges."Student No.",StudCharges.Code,StudCharges."Tuition Fee");
                StudCharges.SetRange(StudCharges."Student No.",Rcpt."Student No.");
                StudCharges.SetRange(StudCharges.Code,"ACA-Receipt Items".Code);
                StudCharges.SetRange(StudCharges."Tuition Fee",true);
                if StudCharges.Find('-') then begin
                "ACA-Receipt Items".Programme:=StudCharges.Programme;
                "ACA-Receipt Items".Stage:=StudCharges.Stage;
                "ACA-Receipt Items".Unit:=StudCharges.Unit;
                "ACA-Receipt Items".Semester:=StudCharges.Semester;
                "ACA-Receipt Items"."Transaction ID":=StudCharges."Transacton ID";
                "ACA-Receipt Items".Modify;

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
        Rcpt: Record UnknownRecord61538;
        CReg: Record UnknownRecord61532;
        StudCharges: Record UnknownRecord61535;
        Receipt_ItemsCaptionLbl: label 'Receipt Items';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

