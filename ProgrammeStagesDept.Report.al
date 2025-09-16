#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51198 "Programme Stages Dept"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Programme Stages Dept.rdlc';

    dataset
    {
        dataitem(UnknownTable61516;UnknownTable61516)
        {
            RequestFilterFields = "Programme Code";
            column(ReportForNavId_3691; 3691)
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
            column(Programme_Stages__Programme_Code_;"Programme Code")
            {
            }
            column(Programme_Stages_Code;Code)
            {
            }
            column(Programme_Stages_Description;Description)
            {
            }
            column(Programme_Stages__G_L_Account_;"G/L Account")
            {
            }
            column(Programme_Stages_Department;Department)
            {
            }
            column(Programme_Stages_Remarks;Remarks)
            {
            }
            column(Programme_StagesCaption;Programme_StagesCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Programme_Stages__Programme_Code_Caption;FieldCaption("Programme Code"))
            {
            }
            column(Programme_Stages_CodeCaption;FieldCaption(Code))
            {
            }
            column(Programme_Stages_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Programme_Stages__G_L_Account_Caption;FieldCaption("G/L Account"))
            {
            }
            column(Programme_Stages_DepartmentCaption;FieldCaption(Department))
            {
            }
            column(Programme_Stages_RemarksCaption;FieldCaption(Remarks))
            {
            }

            trigger OnAfterGetRecord()
            begin
                //IF Prog.GET("ACA-Programme Stages"."Programme Code") THEN BEGIN
                //"ACA-Programme Stages".Department:=Prog."School Code";
                "ACA-Programme Stages"."Include in Time Table":=false;
                "ACA-Programme Stages".Modify;
                //END;
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
        Prog: Record UnknownRecord61511;
        Programme_StagesCaptionLbl: label 'Programme Stages';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

