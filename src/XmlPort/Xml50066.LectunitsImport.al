#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50066 "Lect units Import"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(UnknownTable65210;UnknownTable65210)
            {
                XmlName = 'LecturerUnitsportal';
                fieldelement(Lecturer;"ACA-Lecturers Unitsv2".Lecturer)
                {
                }
                fieldelement(Programme;"ACA-Lecturers Unitsv2".Programme)
                {
                }
                fieldelement(Stage;"ACA-Lecturers Unitsv2".Stage)
                {
                }
                fieldelement(Unit;"ACA-Lecturers Unitsv2".Unit)
                {
                    AutoCalcField = false;
                }
                fieldelement(Semester;"ACA-Lecturers Unitsv2".Semester)
                {
                }
                fieldelement(Remarks;"ACA-Lecturers Unitsv2".Remarks)
                {
                }
                fieldelement(Hours;"ACA-Lecturers Unitsv2"."No. Of Hours")
                {
                }
                fieldelement(Contracthours;"ACA-Lecturers Unitsv2"."No. Of Hours Contracted")
                {
                }
                fieldelement(AvailableFrom;"ACA-Lecturers Unitsv2"."Available From")
                {
                }
                fieldelement(AvailableTo;"ACA-Lecturers Unitsv2"."Available To")
                {
                }
                fieldelement(TimeTableHours;"ACA-Lecturers Unitsv2"."Time Table Hours")
                {
                }
                fieldelement(MinimumContracted;"ACA-Lecturers Unitsv2"."Minimum Contracted")
                {
                }
                fieldelement(Class;"ACA-Lecturers Unitsv2".Class)
                {
                }
                fieldelement(UnitClass;"ACA-Lecturers Unitsv2"."Unit Class")
                {
                }
                fieldelement(StudentType;"ACA-Lecturers Unitsv2"."Student Type")
                {
                }
                fieldelement(Allocation;"ACA-Lecturers Unitsv2".Allocation)
                {
                }
                fieldelement(Description;"ACA-Lecturers Unitsv2".Description)
                {
                }
                fieldelement(Rate;"ACA-Lecturers Unitsv2".Rate)
                {
                }
                fieldelement(Credithours;"ACA-Lecturers Unitsv2"."Credit hours")
                {
                }
                fieldelement("Lect.Hrs";"ACA-Lecturers Unitsv2"."Lect. Hrs")
                {
                }
                fieldelement("Pract.Hrs";"ACA-Lecturers Unitsv2"."Pract. Hrs")
                {
                }
                fieldelement("Tut.Hrs";"ACA-Lecturers Unitsv2"."Tut. Hrs")
                {
                }
                fieldelement(ClassType;"ACA-Lecturers Unitsv2"."Class Type")
                {
                }
                fieldelement(UnitStudentsCount;"ACA-Lecturers Unitsv2"."Unit Students Count")
                {
                }
                fieldelement(UnitResultsCount;"ACA-Lecturers Unitsv2"."Unit Results Count")
                {
                }
                fieldelement(Claimed;"ACA-Lecturers Unitsv2".Claimed)
                {
                }
                fieldelement(ClaimedAmount;"ACA-Lecturers Unitsv2"."Claimed Amount")
                {
                }
                fieldelement(ClaimedDate;"ACA-Lecturers Unitsv2"."Claimed Date")
                {
                }
                fieldelement(CampusCode;"ACA-Lecturers Unitsv2"."Campus Code")
                {
                }
                fieldelement(ClassSize;"ACA-Lecturers Unitsv2"."Class Size")
                {
                }
                fieldelement(Posted;"ACA-Lecturers Unitsv2".Posted)
                {
                }
                fieldelement(PostedBy;"ACA-Lecturers Unitsv2"."Posted By")
                {
                }
                fieldelement(PostedOn;"ACA-Lecturers Unitsv2"."Posted On")
                {
                }
                fieldelement(Amount;"ACA-Lecturers Unitsv2".Amount)
                {
                }
                fieldelement(Approved;"ACA-Lecturers Unitsv2".Approved)
                {
                }
                fieldelement(CATsSubmitted;"ACA-Lecturers Unitsv2"."CATs Submitted")
                {
                }
                fieldelement(ExamsSubmitted;"ACA-Lecturers Unitsv2"."Exams Submitted")
                {
                }
                fieldelement(EngagementTerms;"ACA-Lecturers Unitsv2"."Engagement Terms")
                {
                    AutoCalcField = false;
                }
                fieldelement(UnitCost;"ACA-Lecturers Unitsv2"."Unit Cost")
                {
                }
                fieldelement(MarksSubmitted;"ACA-Lecturers Unitsv2"."Marks Submitted")
                {
                }
                fieldelement(RegisteredStudents;"ACA-Lecturers Unitsv2"."Registered Students")
                {
                }
                fieldelement(Claimtopay;"ACA-Lecturers Unitsv2"."Claim to pay")
                {
                }
                fieldelement(GroupType;"ACA-Lecturers Unitsv2"."Group Type")
                {
                }
                fieldelement(NumberofStudentsRegistered;"ACA-Lecturers Unitsv2"."Number of Students Registered")
                {
                }
                fieldelement(NumberofCATmarksSubmitted;"ACA-Lecturers Unitsv2"."Number of CAT marks Submitted")
                {
                }
                fieldelement(NumberofEXAMmarksSubmitted;"ACA-Lecturers Unitsv2"."Number of EXAM marks Submitted")
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    //MESSAGE('sucess');
                end;
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
}

