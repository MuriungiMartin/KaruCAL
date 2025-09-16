#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51558 "Generate Supplementary/Repeat"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Generate SupplementaryRepeat.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = sorting("Reg. Transacton ID","Student No.",Programme,Semester,"Register for",Stage,Unit,"Student Type");
            RequestFilterFields = Programme,Stage,Unit,"Student No.";
            column(ReportForNavId_2901; 2901)
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
            column(Course_Registration__Student_No__;"Student No.")
            {
            }
            column(Course_Registration__Units_Taken_;"Units Taken")
            {
            }
            column(PassedUnits;PassedUnits)
            {
            }
            column(Units_Taken__PassedUnits;"Units Taken"-PassedUnits)
            {
            }
            column(Cust_Name;Cust.Name)
            {
            }
            column(Remark;Remark)
            {
            }
            column(RCount;RCount)
            {
            }
            column(Pass_ListCaption;Pass_ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Course_Registration__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(Course_Registration__Units_Taken_Caption;FieldCaption("Units Taken"))
            {
            }
            column(Units_PassedCaption;Units_PassedCaptionLbl)
            {
            }
            column(Units_FailedCaption;Units_FailedCaptionLbl)
            {
            }
            column(NamesCaption;NamesCaptionLbl)
            {
            }
            column(RemarkCaption;RemarkCaptionLbl)
            {
            }
            column(Course_Registration_Reg__Transacton_ID;"Reg. Transacton ID")
            {
            }
            column(Course_Registration_Programme;Programme)
            {
            }
            column(Course_Registration_Semester;Semester)
            {
            }
            column(Course_Registration_Register_for;"Register for")
            {
            }
            column(Course_Registration_Stage;Stage)
            {
            }
            column(Course_Registration_Unit;Unit)
            {
            }
            column(Course_Registration_Student_Type;"Student Type")
            {
            }
            column(Course_Registration_Entry_No_;"Entry No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                RCount:=RCount+1;

                PassedUnits:=0;
                Grading.Reset;
                Grading.SetRange(Grading.Category,'DEFAULT');
                Grading.SetRange(Grading.Failed,true);
                if Grading.Find('+') then
                FailScore:=Grading."Up to";

                StudUnits.Reset;
                StudUnits.SetRange(StudUnits."Student No.","ACA-Course Registration"."Student No.");
                StudUnits.SetRange(StudUnits."Reg. Transacton ID","ACA-Course Registration"."Reg. Transacton ID");
                if StudUnits.Find('-') then begin
                repeat
                StudUnits.CalcFields(StudUnits."Total Score");
                if StudUnits."Total Score" > FailScore then
                PassedUnits:=PassedUnits+1;

                until StudUnits.Next = 0;
                end;

                if ("ACA-Course Registration"."Units Taken" - PassedUnits) > 4 then begin
                Remark:='REPEAT';
                StudUnitsR.Reset;
                StudUnitsR.SetRange(StudUnitsR."Student No.","ACA-Course Registration"."Student No.");
                StudUnitsR.SetRange(StudUnitsR."Reg. Transacton ID","ACA-Course Registration"."Reg. Transacton ID");
                if StudUnitsR.Find('-') then begin
                repeat
                StudUnitsR.CalcFields(StudUnitsR."Total Score");
                //StudUnitsR."Repeat Unit":=TRUE;
                StudUnitsR.Modify;

                until StudUnitsR.Next = 0;
                end;


                end else if ("ACA-Course Registration"."Units Taken" - PassedUnits) <= 4 then begin
                //Remark:='SUPPLEMENTARY';
                Remark:='REPEAT';
                StudUnitsR.Reset;
                StudUnitsR.SetRange(StudUnitsR."Student No.","ACA-Course Registration"."Student No.");
                StudUnitsR.SetRange(StudUnitsR."Reg. Transacton ID","ACA-Course Registration"."Reg. Transacton ID");
                if StudUnitsR.Find('-') then begin
                repeat
                StudUnitsR.CalcFields(StudUnitsR."Total Score");
                if StudUnitsR."Total Score" <= FailScore then begin
                //StudUnitsR."Allow Supplementary":=TRUE;
                StudUnitsR.Modify;
                end;

                until StudUnitsR.Next = 0;
                end;


                end else if "ACA-Course Registration"."Units Taken" = PassedUnits then
                Remark:='PASSED';


                if Cust.Get("ACA-Course Registration"."Student No.") then
;

            trigger OnPreDataItem()
            begin
                RCount:=0;
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
        Grading: Record UnknownRecord61569;
        StudUnits: Record UnknownRecord61549;
        StudUnitsR: Record UnknownRecord61549;
        FailScore: Decimal;
        PassedUnits: Integer;
        Remark: Text[150];
        RCount: Integer;
        Pass_ListCaptionLbl: label 'Pass List';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Units_PassedCaptionLbl: label 'Units Passed';
        Units_FailedCaptionLbl: label 'Units Failed';
        NamesCaptionLbl: label 'Names';
        RemarkCaptionLbl: label 'Remark';
}

