#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51683 "Copy Fees Struc"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Copy Fees Struc.rdlc';

    dataset
    {
        dataitem(UnknownTable61523;UnknownTable61523)
        {
            DataItemTableView = sorting("Programme Code","Stage Code",Semester,"Student Type","Settlemet Type","Seq.");
            RequestFilterFields = "Programme Code";
            column(ReportForNavId_2453; 2453)
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
            column(Fee_By_Stage__Programme_Code_;"Programme Code")
            {
            }
            column(Fee_By_Stage__Stage_Code_;"Stage Code")
            {
            }
            column(Fee_By_Stage__Settlemet_Type_;"Settlemet Type")
            {
            }
            column(Fee_By_Stage__Seq__;"Seq.")
            {
            }
            column(Fee_By_Stage__Break_Down_;"Break Down")
            {
            }
            column(Fee_By_Stage_Semester;Semester)
            {
            }
            column(Fee_By_Stage__Student_Type_;"Student Type")
            {
            }
            column(Fee_By_StageCaption;Fee_By_StageCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Fee_By_Stage__Programme_Code_Caption;FieldCaption("Programme Code"))
            {
            }
            column(Fee_By_Stage__Stage_Code_Caption;FieldCaption("Stage Code"))
            {
            }
            column(Fee_By_Stage__Settlemet_Type_Caption;FieldCaption("Settlemet Type"))
            {
            }
            column(Fee_By_Stage__Seq__Caption;FieldCaption("Seq."))
            {
            }
            column(Fee_By_Stage__Break_Down_Caption;FieldCaption("Break Down"))
            {
            }
            column(Fee_By_Stage_SemesterCaption;FieldCaption(Semester))
            {
            }
            column(Fee_By_Stage__Student_Type_Caption;FieldCaption("Student Type"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                FeesByStage.Init;
                FeesByStage."Programme Code":='DPITNEW07';
                FeesByStage."Stage Code":="ACA-Fee By Stage"."Stage Code";
                FeesByStage.Semester:="ACA-Fee By Stage".Semester;
                FeesByStage."Student Type":="ACA-Fee By Stage"."Student Type";
                FeesByStage."Settlemet Type":="ACA-Fee By Stage"."Settlemet Type";
                FeesByStage."Seq.":="ACA-Fee By Stage"."Seq.";
                FeesByStage."Break Down":="ACA-Fee By Stage"."Break Down";
                FeesByStage.Remarks:="ACA-Fee By Stage".Remarks;
                FeesByStage."Amount Not Distributed":="ACA-Fee By Stage"."Amount Not Distributed";
                FeesByStage.Insert;
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
        FeesByStage: Record UnknownRecord61523;
        Fee_By_StageCaptionLbl: label 'Fee By Stage';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

