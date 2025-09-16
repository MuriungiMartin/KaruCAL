#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51521 "Units Allocation"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Units Allocation.rdlc';

    dataset
    {
        dataitem(UnknownTable61517;UnknownTable61517)
        {
            DataItemTableView = sorting("Programme Code","Stage Code",Code);
            RequestFilterFields = "Programme Code","Stage Code",Allocation;
            column(ReportForNavId_2955; 2955)
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
            column(Units_Subjects__Programme_Code_;"Programme Code")
            {
            }
            column(Units_Subjects__Stage_Code_;"Stage Code")
            {
            }
            column(Units_Subjects_Code;Code)
            {
            }
            column(Units_Subjects_Desription;Desription)
            {
            }
            column(RHours;RHours)
            {
            }
            column(Units_Subjects_Allocation;Allocation)
            {
            }
            column(RHours__Credit_Hours_;RHours-"Credit Hours")
            {
            }
            column(Units_Timetable_AllocationCaption;Units_Timetable_AllocationCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Units_Subjects__Programme_Code_Caption;FieldCaption("Programme Code"))
            {
            }
            column(Units_Subjects__Stage_Code_Caption;FieldCaption("Stage Code"))
            {
            }
            column(Units_Subjects_CodeCaption;FieldCaption(Code))
            {
            }
            column(Units_Subjects_DesriptionCaption;FieldCaption(Desription))
            {
            }
            column(Required_HoursCaption;Required_HoursCaptionLbl)
            {
            }
            column(Units_Subjects_AllocationCaption;FieldCaption(Allocation))
            {
            }
            column(VarianceCaption;VarianceCaptionLbl)
            {
            }
            column(Units_Subjects_Entry_No;"Entry No")
            {
            }

            trigger OnAfterGetRecord()
            begin
                RHours:=0;

                if GSetup.Get() then
                RHours:=GSetup."Max Hours Weekly";

                if "ACA-Units/Subjects"."Normal Slots" <> 0 then
                RHours:="ACA-Units/Subjects"."Normal Slots"+"ACA-Units/Subjects"."Lab Slots";
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
        RHours: Decimal;
        GSetup: Record UnknownRecord61534;
        Units_Timetable_AllocationCaptionLbl: label 'Units Timetable Allocation';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Required_HoursCaptionLbl: label 'Required Hours';
        VarianceCaptionLbl: label 'Variance';
}

