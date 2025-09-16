#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 69276 "Lecturer Exam Entry Statistics"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Lecturer Exam Entry Statistics.rdlc';

    dataset
    {
        dataitem(UnknownTable65201;UnknownTable65201)
        {
            PrintOnlyIfDetail = true;
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
            column(Log;CompanyInformation.Picture)
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
            column(Faculty;"Lect Load Batch Lines".Faculty)
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
            column(GroupingConcortion;"Lect Load Batch Lines"."Department Code"+"Lect Load Batch Lines".Campus+"Lect Load Batch Lines"."Semester Code")
            {
            }
            column(DeptCode;"Lect Load Batch Lines"."Department Code")
            {
            }
            column(Campus;"Lect Load Batch Lines".Campus)
            {
            }
            column(Department;"Lect Load Batch Lines"."Department Name")
            {
            }
            dataitem(UnknownTable65202;UnknownTable65202)
            {
                CalcFields = "Number of Students Registered","Number of CAT marks Submitted","Number of EXAM marks Submitted";
                DataItemLink = Lecturer=field("Lecturer Code"),Semester=field("Semester Code");
                RequestFilterFields = Programme,Stage,Semester;
                column(ReportForNavId_1000000032; 1000000032)
                {
                }
                column(UnitStage;"ACA-Lecturers Units".Stage)
                {
                }
                column(UnitProg;ProgName)
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
                column(MarksSubmitted;"ACA-Lecturers Units"."Marks Submitted")
                {
                }
                column(AngagementTerms;"ACA-Lecturers Units"."Engagement Terms")
                {
                }
                column(ExamsSubmitted;"ACA-Lecturers Units"."Exams Submitted")
                {
                }
                column(CatsSubmitted;"ACA-Lecturers Units"."CATs Submitted")
                {
                }
                column(Approved;"ACA-Lecturers Units".Approved)
                {
                }
                column(seq;seq)
                {
                }
                column(Registered;"ACA-Lecturers Units"."Number of Students Registered")
                {
                }
                column(CatCount;"ACA-Lecturers Units"."Number of CAT marks Submitted")
                {
                }
                column(ExamCount;"ACA-Lecturers Units"."Number of EXAM marks Submitted")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    seq:=seq+1;
                    Clear(ProgName);
                    prog.Reset;
                    prog.SetRange(Code,"ACA-Lecturers Units".Programme);
                    if prog.Find('-')then begin
                      ProgName:=prog.Description;
                      end;
                end;
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
                Clear(seq);
                // prog.RESET;
                // prog.SETRANGE(Code,"ACA-Lecturers Units".Programme);
                // IF prog.FIND('-')THEN BEGIN
                //  ProgName:=prog.Description;
                //  END;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

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
         CompanyInformation.CalcFields(Picture);
           end;
    end;

    var
        CompanyInformation: Record "Company Information";
        HRMEmployeeC: Record UnknownRecord61188;
        ACASemester: Record UnknownRecord61692;
        seq: Integer;
        prog: Record UnknownRecord61511;
        ProgName: Text[250];
}

