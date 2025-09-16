#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51435 "Committees Board Of Directors"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Committees Board Of Directors.rdlc';

    dataset
    {
        dataitem(UnknownTable61286;UnknownTable61286)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code";
            column(ReportForNavId_1229; 1229)
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
            column(Committees_Code;Code)
            {
            }
            column(Committees_Description;Description)
            {
            }
            column(CommitteesCaption;CommitteesCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Committees_CodeCaption;FieldCaption(Code))
            {
            }
            column(Committees_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Committee_Board_Of_Directors_CodeCaption;"HRM-Committee Board Of Direct.".FieldCaption(Code))
            {
            }
            column(Committee_Board_Of_Directors_SurNameCaption;"HRM-Committee Board Of Direct.".FieldCaption(SurName))
            {
            }
            column(Committee_Board_Of_Directors_OtherNamesCaption;"HRM-Committee Board Of Direct.".FieldCaption(OtherNames))
            {
            }
            column(Committee_Board_Of_Directors_DesignationCaption;"HRM-Committee Board Of Direct.".FieldCaption(Designation))
            {
            }
            column(Committee_Board_Of_Directors_RemarksCaption;"HRM-Committee Board Of Direct.".FieldCaption(Remarks))
            {
            }
            dataitem(UnknownTable61328;UnknownTable61328)
            {
                DataItemLink = Committee=field(Code);
                column(ReportForNavId_3802; 3802)
                {
                }
                column(Committee_Board_Of_Directors_Code;Code)
                {
                }
                column(Committee_Board_Of_Directors_SurName;SurName)
                {
                }
                column(Committee_Board_Of_Directors_OtherNames;OtherNames)
                {
                }
                column(Committee_Board_Of_Directors_Designation;Designation)
                {
                }
                column(Committee_Board_Of_Directors_Remarks;Remarks)
                {
                }
                column(Committee_Board_Of_Directors_Committee;Committee)
                {
                }
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
        CommitteesCaptionLbl: label 'Committees';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

