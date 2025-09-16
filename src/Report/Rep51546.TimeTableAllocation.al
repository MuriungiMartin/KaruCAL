#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51546 "Time Table Allocation"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Time Table Allocation.rdlc';

    dataset
    {
        dataitem(UnknownTable61517;UnknownTable61517)
        {
            DataItemTableView = sorting("Programme Code","Stage Code",Code,"Programme Option");
            RequestFilterFields = "Programme Code","Stage Code","Not Allocated","Slots Varience";
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
            column(Allocated;Allocated)
            {
            }
            column(Units_Subjects__Slots_Varience_;"Slots Varience")
            {
            }
            column(Time_Table_AllocationCaption;Time_Table_AllocationCaptionLbl)
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
            column(Units_Subjects__Slots_Varience_Caption;FieldCaption("Slots Varience"))
            {
            }
            column(AllocatedCaption;AllocatedCaptionLbl)
            {
            }
            column(Units_Subjects_Entry_No;"Entry No")
            {
            }

            trigger OnAfterGetRecord()
            begin
                PrevU:=false;
                PrevP:=false;

                if PUnit="ACA-Units/Subjects".Code then
                PrevU:=true;

                PUnit:="ACA-Units/Subjects".Code;

                if PProg="ACA-Units/Subjects"."Programme Code" then
                PrevP:=true;

                PProg:="ACA-Units/Subjects"."Programme Code";


                Allocated:=true;
                if "ACA-Units/Subjects"."Not Allocated" = true then
                Allocated:=false
                else
                Allocated:=true;

                if "ACA-Units/Subjects"."Slots Varience" > 0 then
                Allocated:=false;
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
        PUnit: Code[20];
        PrevU: Boolean;
        PrevP: Boolean;
        PProg: Code[20];
        Allocated: Boolean;
        Time_Table_AllocationCaptionLbl: label 'Time Table Allocation';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        AllocatedCaptionLbl: label 'Allocated';
}

