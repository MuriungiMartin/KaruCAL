#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 65201 "Lecturer Appointment Laters"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Lecturer Appointment Laters.rdlc';

    dataset
    {
        dataitem(UnknownTable65201;UnknownTable65201)
        {
            RequestFilterFields = "Semester Code","Lecturer Code";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(CompName;CompanyInformation.Name)
            {
            }
            column(CompPhones;CompanyInformation."Phone No."+'\'+CompanyInformation."Phone No. 2")
            {
            }
            column(CompMails;CompanyInformation."Home Page"+'\'+CompanyInformation."E-Mail")
            {
            }
            column(CompAddresses;CompanyInformation.Address+'\'+CompanyInformation."Address 2"+' - '+CompanyInformation.City)
            {
            }
            column(EmpNames;HRMEmployeeC."First Name"+' '+HRMEmployeeC."Middle Name"+' '+HRMEmployeeC."Last Name")
            {
            }
            column(Salutations;Format(HRMEmployeeC.Title))
            {
            }
            column(SemesterDesc;ACASemester.Description)
            {
            }
            column(Lname;HRMEmployeeC."Last Name")
            {
            }
            column(fName;HRMEmployeeC."First Name")
            {
            }
            column(MName;HRMEmployeeC."Middle Name")
            {
            }
            column(Amount;"Lect Load Batch Lines".Amount)
            {
            }
            column(Rangedescription;"Lect Load Batch Lines"."Semester Range Descption")
            {
            }
            column(FacName;"Lect Load Batch Lines"."Faculty Name")
            {
            }
            column(Semester;"Lect Load Batch Lines"."Semester Code")
            {
            }
            column(LectCode;"Lect Load Batch Lines"."Lecturer Code")
            {
            }
            column(Approve;"Lect Load Batch Lines".Approve)
            {
            }
            column(Reject;"Lect Load Batch Lines".Reject)
            {
            }
            column(RejectReason;"Lect Load Batch Lines"."Reject Reason")
            {
            }
            column(ClaimNo;"Lect Load Batch Lines"."Claim No.")
            {
            }
            column(PVNo;"Lect Load Batch Lines"."PV No.")
            {
            }
            column(ClaimInitiatedBy;"Lect Load Batch Lines"."Claim Initiated By")
            {
            }
            column(PVCreatedDate;"Lect Load Batch Lines"."PV Created Date")
            {
            }
            column(RejectBy;"Lect Load Batch Lines"."Rejected By")
            {
            }
            column(RejectDate;"Lect Load Batch Lines"."Rejected Time")
            {
            }
            column(CreatedBy;"Lect Load Batch Lines"."Created By")
            {
            }
            column(CreatedTime;"Lect Load Batch Lines"."Created Time")
            {
            }
            column(ClaimInitiatedDate;"Lect Load Batch Lines"."Claim Initiated Date")
            {
            }
            column(PVCreatedTime;"Lect Load Batch Lines"."PV Created Time")
            {
            }
            column(PVStatus;"Lect Load Batch Lines"."PV Status")
            {
            }
            column(ClaimStatus;"Lect Load Batch Lines"."Claim Status")
            {
            }
            column(ClaimCurrApprover;"Lect Load Batch Lines"."Claim Current Approver")
            {
            }
            column(PVCurrentApprove;"Lect Load Batch Lines"."PV Current Approver")
            {
            }
            column(Faculty;facultyName)
            {
            }
            column(AppointRefNo;"Lect Load Batch Lines"."Appointment Later Ref. No.")
            {
            }
            column(AppointRef;"Lect Load Batch Lines"."Appointment Later Ref.")
            {
            }
            column(PhoneNo;"Lect Load Batch Lines".Phone)
            {
            }
            column(UnitsCount;"Lect Load Batch Lines"."Courses Count")
            {
            }
            column(AppLetterRef;"Lect Load Batch Lines"."Appointment Later Ref. No.")
            {
            }
            column(AppLetterRef2;"Lect Load Batch Lines"."Appointment Later Ref.")
            {
            }
            column(SemRangeDesc;"Lect Load Batch Lines"."Semester Range Descption")
            {
            }
            column(ApprovalName;"Lect Load Batch Lines"."Approval Name")
            {
            }
            column(ApprovalTitle;"Lect Load Batch Lines"."Approval Title")
            {
            }
            column(GroupingConcortion;"Lect Load Batch Lines"."Semester Code"+"Lect Load Batch Lines"."Lecturer Code")
            {
            }
            dataitem(UnknownTable65202;UnknownTable65202)
            {
                DataItemLink = Lecturer=field("Lecturer Code"),Semester=field("Semester Code");
                DataItemTableView = where("Unit Cost"=filter(<>0));
                column(ReportForNavId_1000000032; 1000000032)
                {
                }
                column(UnitStage;"ACA-Lecturers Units".Stage)
                {
                }
                column(UnitProg;"ACA-Lecturers Units".Programme)
                {
                }
                column(UnitCode;"ACA-Lecturers Units".Unit)
                {
                }
                column(Lect;"ACA-Lecturers Units".Lecturer)
                {
                }
                column(UnitDesc;"ACA-Lecturers Units".Description)
                {
                }
                column(UnitCost;"ACA-Lecturers Units"."Unit Cost")
                {
                }
                column(Class;"ACA-Lecturers Units".Class)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                HRMEmployeeC.Reset;
                HRMEmployeeC.SetRange("No.","Lect Load Batch Lines"."Lecturer Code");
                if HRMEmployeeC.Find('-') then begin
                  end;
                ACASemester.Reset;
                ACASemester.SetRange(Code,"Lect Load Batch Lines"."Semester Code");
                if ACASemester.Find('-') then
                  ACASemester.Validate(ACASemester.Description);
                Clear(facultyName);
                ACALecturersUnits.Reset;
                ACALecturersUnits.SetRange(Semester,"Lect Load Batch Lines"."Semester Code");
                ACALecturersUnits.SetRange(Lecturer,"Lect Load Batch Lines"."Lecturer Code");
                ACALecturersUnits.SetRange(Approved,true);
                if ACALecturersUnits.Find('-') then begin
                 if ACAProgramme.Get(ACALecturersUnits.Programme) then begin
                    DimensionValue.Reset;
                   DimensionValue.SetRange("Dimension Code",'SCHOOL');
                   DimensionValue.SetRange(Code,ACAProgramme."School Code");
                   if DimensionValue.Find('-') then begin
                     facultyName:=DimensionValue.Name;
                     end;
                   end;
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
        CompanyInformation.Reset;
        if CompanyInformation.Find('-') then begin
          end;
    end;

    var
        CompanyInformation: Record "Company Information";
        HRMEmployeeC: Record UnknownRecord61188;
        ACASemester: Record UnknownRecord61692;
        ACALecturersUnits: Record UnknownRecord65202;
        ACAProgramme: Record UnknownRecord61511;
        DimensionValue: Record "Dimension Value";
        facultyName: Text[250];
}

