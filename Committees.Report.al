#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51434 Committees
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Committees.rdlc';

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
            column(Committees_Comments;Comments)
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
            column(Committees_CommentsCaption;FieldCaption(Comments))
            {
            }
            dataitem(UnknownTable61328;UnknownTable61328)
            {
                DataItemLink = Committee=field(Code);
                column(ReportForNavId_1000000000; 1000000000)
                {
                }
                column(Code_CommitteeBoardOfDirectors;"HRM-Committee Board Of Direct.".Code)
                {
                }
                column(SurName_CommitteeBoardOfDirectors;"HRM-Committee Board Of Direct.".SurName)
                {
                }
                column(OtherNames_CommitteeBoardOfDirectors;"HRM-Committee Board Of Direct.".OtherNames)
                {
                }
                column(Designation_CommitteeBoardOfDirectors;"HRM-Committee Board Of Direct.".Designation)
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

