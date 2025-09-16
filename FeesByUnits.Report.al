#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51648 "Fees By Units"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Fees By Units.rdlc';

    dataset
    {
        dataitem(UnknownTable61524;UnknownTable61524)
        {
            DataItemTableView = sorting("Programme Code","Stage Code","Unit Code",Semester,"Student Type","Settlemet Type","Seq.");
            RequestFilterFields = "Programme Code","Stage Code";
            column(ReportForNavId_7267; 7267)
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
            column(Fee_By_Unit__Programme_Code_;"Programme Code")
            {
            }
            column(Fee_By_Unit__Stage_Code_;"Stage Code")
            {
            }
            column(Fee_By_Unit__Programme_Code__Control1000000014;"Programme Code")
            {
            }
            column(Fee_By_Unit__Stage_Code__Control1000000017;"Stage Code")
            {
            }
            column(Fee_By_Unit__Unit_Code_;"Unit Code")
            {
            }
            column(Fee_By_Unit__Settlemet_Type_;"Settlemet Type")
            {
            }
            column(Fee_By_Unit__Seq__;"Seq.")
            {
            }
            column(Fee_By_Unit__Break_Down_;"Break Down")
            {
            }
            column(Fee_By_Unit__Student_Type_;"Student Type")
            {
            }
            column(Fee_By_UnitCaption;Fee_By_UnitCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Fee_By_Unit__Programme_Code__Control1000000014Caption;FieldCaption("Programme Code"))
            {
            }
            column(Fee_By_Unit__Stage_Code__Control1000000017Caption;FieldCaption("Stage Code"))
            {
            }
            column(Fee_By_Unit__Unit_Code_Caption;FieldCaption("Unit Code"))
            {
            }
            column(Fee_By_Unit__Settlemet_Type_Caption;FieldCaption("Settlemet Type"))
            {
            }
            column(Fee_By_Unit__Seq__Caption;FieldCaption("Seq."))
            {
            }
            column(Fee_By_Unit__Break_Down_Caption;FieldCaption("Break Down"))
            {
            }
            column(Fee_By_Unit__Student_Type_Caption;FieldCaption("Student Type"))
            {
            }
            column(Fee_By_Unit__Programme_Code_Caption;FieldCaption("Programme Code"))
            {
            }
            column(Fee_By_Unit__Stage_Code_Caption;FieldCaption("Stage Code"))
            {
            }
            column(Fee_By_Unit_Semester;Semester)
            {
            }

            trigger OnAfterGetRecord()
            begin
                FeesByUnit.Init;
                FeesByUnit."Programme Code":='CPS';
                FeesByUnit."Stage Code":="ACA-Fee By Unit"."Stage Code";
                FeesByUnit."Unit Code":="ACA-Fee By Unit"."Unit Code";
                FeesByUnit.Semester:="ACA-Fee By Unit".Semester;
                FeesByUnit."Student Type":="ACA-Fee By Unit"."Student Type";
                FeesByUnit."Settlemet Type":="ACA-Fee By Unit"."Settlemet Type";
                FeesByUnit."Seq.":="ACA-Fee By Unit"."Seq.";
                FeesByUnit."Break Down":="ACA-Fee By Unit"."Break Down";
                FeesByUnit.Remarks:="ACA-Fee By Unit".Remarks;
                FeesByUnit.Insert;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Stage Code");
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
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        FeesByUnit: Record UnknownRecord61524;
        Fee_By_UnitCaptionLbl: label 'Fee By Unit';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

