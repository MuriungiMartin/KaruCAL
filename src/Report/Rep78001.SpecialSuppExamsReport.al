#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78001 "Special/Supp. Exams Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/SpecialSupp. Exams Report.rdlc';

    dataset
    {
        dataitem(UnknownTable78002;UnknownTable78002)
        {
            DataItemLink = Semester=field(Field2),"Exam Session"=field(Field3),"Student No."=field(Field4),Stage=field(Field5),Programme=field(Field6);
            column(ReportForNavId_1000000053; 1000000053)
            {
            }
            column(CompName;CompanyInformation.Name)
            {
            }
            column(Address1;CompanyInformation.Address)
            {
            }
            column(Address2;CompanyInformation."Address 2")
            {
            }
            column(Phone1;CompanyInformation."Phone No.")
            {
            }
            column(Phone2;CompanyInformation."Phone No. 2")
            {
            }
            column(Pics;CompanyInformation.Picture)
            {
            }
            column(Email;CompanyInformation."E-Mail")
            {
            }
            column(HomeP;CompanyInformation."Home Page")
            {
            }
            column(StudentNo;"Aca-Special Exams Details"."Student No.")
            {
            }
            column(StdName;Customer.Name)
            {
            }
            column(Category;UpperCase(Format("Aca-Special Exams Details".Category)+' Examinations'))
            {
            }
            column(Stage;"Aca-Special Exams Details".Stage)
            {
            }
            column(AcadYear;"Aca-Special Exams Details"."Academic Year")
            {
            }
            column(ExamSession;"Aca-Special Exams Details"."Current Academic Year")
            {
            }
            column(UnitCount;1)
            {
            }
            column(TotalCharge;0)
            {
            }
            column(UnitCharge;0)
            {
            }
            column(Semester;"Aca-Special Exams Details".Semester)
            {
            }
            column(ProgCode;"Aca-Special Exams Details".Programme)
            {
            }
            column(ProgName;ACAProgramme.Description)
            {
            }
            column(GroupByPhrase;"Aca-Special Exams Details"."Student No."+"Aca-Special Exams Details".Stage+"Aca-Special Exams Details".Programme+"Aca-Special Exams Details".Semester)
            {
            }
            column(UnitCode;"Aca-Special Exams Details"."Unit Code")
            {
            }
            column(UnitDescription;"Aca-Special Exams Details"."Unit Description")
            {
            }
            column(CostPerUnit;"Aca-Special Exams Details"."Cost Per Exam")
            {
            }
            column(UnitCountApproved;'')
            {
            }
            column(TotalApprovedCharge;'')
            {
            }
            column(UnitChargeApproved;'')
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Customer.Get("Aca-Special Exams Details"."Student No.") then begin
                  end;
                  if ACAProgramme.Get("Aca-Special Exams Details".Programme) then begin
                    end;
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

    trigger OnInitReport()
    begin
        if CompanyInformation.Get then begin
          CompanyInformation.CalcFields(Picture);
          end;
    end;

    var
        ACAProgramme: Record UnknownRecord61511;
        Customer: Record Customer;
        CompanyInformation: Record "Company Information";
}

