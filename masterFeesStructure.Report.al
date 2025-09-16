#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51483 "master Fees Structure"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/master Fees Structure.rdlc';

    dataset
    {
        dataitem(UnknownTable61555;UnknownTable61555)
        {
            DataItemTableView = sorting("Stage Code",Semester,"Student Type","Settlemet Type","Seq.");
            RequestFilterFields = "Stage Code",Semester,"Student Type","Settlemet Type","Seq.";
            column(ReportForNavId_3609; 3609)
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
            column(Master_Fee_Structure__Settlemet_Type_;"Settlemet Type")
            {
            }
            column(Master_Fee_Structure_Semester;Semester)
            {
            }
            column(Master_Fee_Structure__Student_Type_;"Student Type")
            {
            }
            column(Master_Fee_Structure__Break_Down_;"Break Down")
            {
            }
            column(Master_Fee_StructureCaption;Master_Fee_StructureCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Master_Fee_Structure__Settlemet_Type_Caption;FieldCaption("Settlemet Type"))
            {
            }
            column(Master_Fee_Structure_SemesterCaption;FieldCaption(Semester))
            {
            }
            column(Master_Fee_Structure__Student_Type_Caption;FieldCaption("Student Type"))
            {
            }
            column(Master_Student_Charges__Stage_Code_Caption;"ACA-Master Student Charges".FieldCaption("Stage Code"))
            {
            }
            column(Master_Student_Charges_AmountCaption;"ACA-Master Student Charges".FieldCaption(Amount))
            {
            }
            column(Master_Student_Charges_DescriptionCaption;"ACA-Master Student Charges".FieldCaption(Description))
            {
            }
            column(Master_Fee_Structure__Break_Down_Caption;FieldCaption("Break Down"))
            {
            }
            column(Master_Fee_Structure_Stage_Code;"Stage Code")
            {
            }
            column(Master_Fee_Structure_Seq_;"Seq.")
            {
            }
            dataitem(UnknownTable61556;UnknownTable61556)
            {
                DataItemLink = "Student Type"=field("Student Type");
                column(ReportForNavId_4786; 4786)
                {
                }
                column(Master_Student_Charges_Description;Description)
                {
                }
                column(Master_Student_Charges_Amount;Amount)
                {
                }
                column(Master_Student_Charges__Stage_Code_;"Stage Code")
                {
                }
                column(Master_Student_Charges_Code;Code)
                {
                }
                column(Master_Student_Charges_Student_Type;"Student Type")
                {
                }
            }
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
        Master_Fee_StructureCaptionLbl: label 'Master Fee Structure';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

