#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51343 "Official Admission LetterJAb"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Official Admission LetterJAb.rdlc';

    dataset
    {
        dataitem("Application Form Header";UnknownTable70082)
        {
            column(ReportForNavId_1102755000; 1102755000)
            {
            }
            column(ApplicationNo_ApplicationFormHeader;"Application Form Header".Admin)
            {
            }
            column(Surname_ApplicationFormHeader;"Application Form Header".Names)
            {
            }
            column(OtherNames_ApplicationFormHeader;"Application Form Header".Names)
            {
            }
            column(Gender_ApplicationFormHeader;"Application Form Header".Gender)
            {
            }
            column(address;"Application Form Header".Box)
            {
            }
            column(adresscode;"Application Form Header".Codes)
            {
            }
            column(addresstown;"Application Form Header".Town)
            {
            }
            column(TelephoneNo1_ApplicationFormHeader;"Application Form Header".Phone)
            {
            }
            column(TelephoneNo2_ApplicationFormHeader;"Application Form Header"."Alt. Phone")
            {
            }
            column(Degree;"Application Form Header".Prog)
            {
            }
            column(School;"Application Form Header"."Slt Mail")
            {
            }
            column(IndexNumber_ApplicationFormHeader;"Application Form Header".Index)
            {
            }
            column(AcademicYear_ApplicationFormHeader;"Application Form Header".Admin)
            {
            }
            column(AdmissionNo_ApplicationFormHeader;"Application Form Header".Admin)
            {
            }
            column(Names_ApplicationFormHeader;"Application Form Header".Names)
            {
            }
            column(Surname_ApplicationFormHeader1;"Application Form Header".Names)
            {
            }
            column(CompName;CompName)
            {
            }
            column(Faculty;FacultyName)
            {
            }
            column(RepDate;ReportDate)
            {
            }
            column(FNames;FullNames)
            {
            }
            column(ProgName;ProgName)
            {
            }
            column(DateStr;DateStr)
            {
            }
            column(AdminNo;Admin)
            {
            }
            column(email;Email)
            {
            }
            column(Salutation;Salutation)
            {
            }
            column(StageName;StageName)
            {
            }
            dataitem("New Student Charges";UnknownTable61543)
            {
                DataItemLink = "Programme Code"=field(Prog);
                column(ReportForNavId_1000000000; 1000000000)
                {
                }
                column(Code_NewStudentCharges;"New Student Charges".Code)
                {
                }
                column(Description_NewStudentCharges;"New Student Charges".Description)
                {
                }
                column(Amount_NewStudentCharges;"New Student Charges".Amount)
                {
                }
            }

            trigger OnAfterGetRecord()
            var
                TTTT: Text[30];
            begin
                   CompName:=COMPANYNAME;
                  // FullNames:="Application Form Header".Surname+' '+"Application Form Header"."Other Names";
                   ProgName:='';
                   if Prog1.Get("Application Form Header".Prog) then begin
                   ProgName:=Prog1.Description;
                    FacultyName:='';
                    FacRec.Reset;
                    FacRec.SetRange("Dimension Code",'SCHOOL');
                    FacRec.SetRange(FacRec.Code,Prog1."School Code");
                    if FacRec.Find('-') then
                    FacultyName:=FacRec.Name;
                   end;

                  // IF IntakeRec.GET("Application Form Header"."Intake Code") THEN BEGIN
                    if IntakeRec.Current=true then begin
                     IntakeRec.TestField(IntakeRec."Reporting Date");
                    ReportDate:= Format(IntakeRec."Reporting Date",0,'<Day> <Month Text>') +' '+Format(Date2dmy(IntakeRec."Reporting Date",3));
                 end;
                   DateStr:= Format(Today,0,'<Day> <Month Text>') +' '+Format(Date2dmy(Today,3));


                    StageRec.Reset;
                    StageRec.SetRange(StageRec."Programme Code","Application Form Header".Prog);
                   // StageRec.SETRANGE(StageRec.Code,"Application Form Header"."Admitted To Stage");
                    if StageRec.Find('-') then
                    StageName:=CopyStr(StageRec.Description,1,7);
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
        StageName: Text[100];
        CompName: Code[100];
        ReportDate: Text;
        FullNames: Text[100];
        ProgName: Code[100];
        Prog1: Record UnknownRecord61511;
        IntakeRec: Record UnknownRecord61383;
        ComenceDate: Date;
        DateStr: Text[50];
        FacultyName: Text[100];
        FacRec: Record "Dimension Value";
        StudHostel: Record "ACA-Students Hostel Rooms";
        RoomNo: Code[20];
        HostelRec: Record "ACA-Hostel Card";
        HostelName: Text[50];
        StageRec: Record UnknownRecord61516;
        email: Code[30];
        Telphone: Code[20];
        Admin: Code[20];
        address: Code[10];
        Salutation: Text;
}

