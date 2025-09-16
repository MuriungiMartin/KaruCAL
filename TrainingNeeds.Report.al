#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51451 "Training Needs"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Training Needs.rdlc';

    dataset
    {
        dataitem(UnknownTable61334;UnknownTable61334)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code";
            column(ReportForNavId_3781; 3781)
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
            column(Training_Needs_Code;Code)
            {
            }
            column(Training_Needs_Description;Description)
            {
            }
            column(Training_Needs__Start_Date_;"Start Date")
            {
            }
            column(Training_Needs__End_Date_;"End Date")
            {
            }
            column(Training_Needs__Duration_Units_;"Duration Units")
            {
            }
            column(Training_Needs_Duration;Duration)
            {
            }
            column(Training_Needs__Cost_Of_Training_;"Cost Of Training")
            {
            }
            column(Training_Needs_Qualification;Qualification)
            {
            }
            column(Training_Needs__Re_Assessment_Date_;"Re-Assessment Date")
            {
            }
            column(Training_Needs_Source;Source)
            {
            }
            column(Training_Needs__Need_Source_;"Need Source")
            {
            }
            column(Training_Needs_Provider;Provider)
            {
            }
            column(Training_Needs__Department_Code_;"Department Code")
            {
            }
            column(Training_NeedsCaption;Training_NeedsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Training_Needs_CodeCaption;FieldCaption(Code))
            {
            }
            column(Training_Needs_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Training_Needs__Start_Date_Caption;FieldCaption("Start Date"))
            {
            }
            column(Training_Needs__End_Date_Caption;FieldCaption("End Date"))
            {
            }
            column(Training_Needs__Duration_Units_Caption;FieldCaption("Duration Units"))
            {
            }
            column(Training_Needs_DurationCaption;FieldCaption(Duration))
            {
            }
            column(Training_Needs__Cost_Of_Training_Caption;FieldCaption("Cost Of Training"))
            {
            }
            column(Training_Needs_QualificationCaption;FieldCaption(Qualification))
            {
            }
            column(Training_Needs__Re_Assessment_Date_Caption;FieldCaption("Re-Assessment Date"))
            {
            }
            column(Training_Needs_SourceCaption;FieldCaption(Source))
            {
            }
            column(Training_Needs__Need_Source_Caption;FieldCaption("Need Source"))
            {
            }
            column(Training_Needs_ProviderCaption;FieldCaption(Provider))
            {
            }
            column(Training_Needs__Department_Code_Caption;FieldCaption("Department Code"))
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo(Code);
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
        Training_NeedsCaptionLbl: label 'Training Needs';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

