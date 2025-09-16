#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51340 "TMU Admission letter- Dip/Cert"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/TMU Admission letter- DipCert.rdlc';

    dataset
    {
        dataitem(UnknownTable61358;UnknownTable61358)
        {
            column(ReportForNavId_1102755000; 1102755000)
            {
            }
            column(AdmissionNo_AdmissionFormHeader;"ACA-Applic. Form Header"."Application No.")
            {
            }
            column(Date_AdmissionFormHeader;"ACA-Applic. Form Header".Date)
            {
            }
            column(AdmissionType_AdmissionFormHeader;"ACA-Applic. Form Header"."Settlement Type")
            {
            }
            column(JABSNo_AdmissionFormHeader;"ACA-Applic. Form Header"."Admission No")
            {
            }
            column(AcademicYear_AdmissionFormHeader;"ACA-Applic. Form Header"."Academic Year")
            {
            }
            column(ApplicationNo_AdmissionFormHeader;"ACA-Applic. Form Header"."Admission No"+':')
            {
            }
            column(Surname_AdmissionFormHeader;"ACA-Applic. Form Header".Surname)
            {
            }
            column(OtherNames_AdmissionFormHeader;"ACA-Applic. Form Header"."Other Names")
            {
            }
            column(FacultyAdmittedTo_AdmissionFormHeader;"ACA-Applic. Form Header".School1)
            {
            }
            column(DegreeAdmittedTo_AdmissionFormHeader;"ACA-Applic. Form Header"."First Degree Choice")
            {
            }
            column(DateOfBirth_AdmissionFormHeader;"ACA-Applic. Form Header"."Date Of Birth")
            {
            }
            column(Gender_AdmissionFormHeader;"ACA-Applic. Form Header".Gender)
            {
            }
            column(MaritalStatus_AdmissionFormHeader;"ACA-Applic. Form Header"."Marital Status")
            {
            }
            column(SpouseName_AdmissionFormHeader;'  ')
            {
            }
            column(SpouseAddress1_AdmissionFormHeader;'   ')
            {
            }
            column(SpouseAddress2_AdmissionFormHeader;'      ')
            {
            }
            column(SpouseAddress3_AdmissionFormHeader;'    ')
            {
            }
            column(PlaceOfBirthVillage_AdmissionFormHeader;'    ')
            {
            }
            column(PlaceOfBirthLocation_AdmissionFormHeader;'       ')
            {
            }
            column(PlaceOfBirthDistrict_AdmissionFormHeader;'             ')
            {
            }
            column(NameofChief_AdmissionFormHeader;'                 ')
            {
            }
            column(NearestPoliceStation_AdmissionFormHeader;'                        ')
            {
            }
            column(Nationality_AdmissionFormHeader;"ACA-Applic. Form Header".Nationality)
            {
            }
            column(Religion_AdmissionFormHeader;'.')
            {
            }
            column(CorrespondenceAddress1_AdmissionFormHeader;"ACA-Applic. Form Header"."Address for Correspondence1")
            {
            }
            column(CorrespondenceAddress2_AdmissionFormHeader;"ACA-Applic. Form Header"."Address for Correspondence2")
            {
            }
            column(CorrespondenceAddress3_AdmissionFormHeader;"ACA-Applic. Form Header"."Address for Correspondence3")
            {
            }
            column(TelephoneNo1_AdmissionFormHeader;"ACA-Applic. Form Header"."Telephone No. 1")
            {
            }
            column(TelephoneNo2_AdmissionFormHeader;"ACA-Applic. Form Header"."Telephone No. 2")
            {
            }
            column(FaxNo_AdmissionFormHeader;',.')
            {
            }
            column(EMail_AdmissionFormHeader;"ACA-Applic. Form Header".Email)
            {
            }
            column(StageAdmittedTo_AdmissionFormHeader;"ACA-Applic. Form Header"."First Choice Stage")
            {
            }
            column(SemesterAdmittedTo_AdmissionFormHeader;"ACA-Applic. Form Header"."First Choice Semester")
            {
            }
            column(SettlementType_AdmissionFormHeader;"ACA-Applic. Form Header"."Settlement Type")
            {
            }
            column(IntakeCode_AdmissionFormHeader;"ACA-Applic. Form Header"."Intake Code")
            {
            }
            column(IDNumber_AdmissionFormHeader;"ACA-Applic. Form Header"."ID Number")
            {
            }
            column(Title;"ACA-Applic. Form Header".Title)
            {
            }
            column(Campus_AdmissionFormHeader;"ACA-Applic. Form Header".Campus)
            {
            }
            column(CompName;UpperCase(CompName))
            {
            }
            column(RepDate;ReportDate)
            {
            }
            column(FNames;FullNames)
            {
            }
            column(YearName;YearName)
            {
            }
            column(ProgName;ProgName)
            {
            }
            column(DateStr;DateStr)
            {
            }
            column(Faculty;FacultyName)
            {
            }
            column(ttl;ttl)
            {
            }
            column(repEndDate;repEndDate)
            {
            }
            column(signName;applicSet."Admission Letter Signatory Nam")
            {
            }
            column(SignTitle;applicSet."Admission Letter Sign. Title")
            {
            }
            column(titleAndFullName;"ACA-Applic. Form Header".Surname)
            {
            }
            column(ProgCategory;ProgCategory)
            {
            }
            column(counted1;counted2[1])
            {
            }
            column(counted2;counted2[2])
            {
            }
            column(counted3;counted2[3])
            {
            }
            column(counted4;counted2[4])
            {
            }
            column(counted5;counted2[5])
            {
            }
            column(counted6;counted2[6])
            {
            }
            column(counted7;counted2[7])
            {
            }
            column(counted8;counted2[8])
            {
            }
            column(counted9;counted2[9])
            {
            }
            column(counted10;counted2[10])
            {
            }
            column(counted11;counted2[11])
            {
            }
            column(counted12;counted2[12])
            {
            }
            column(counted13;counted2[13])
            {
            }
            column(chargeDesc1;chargeDesc[1])
            {
            }
            column(chargeDesc2;chargeDesc[2])
            {
            }
            column(chargeDesc3;chargeDesc[3])
            {
            }
            column(chargeDesc4;chargeDesc[4])
            {
            }
            column(chargeDesc5;chargeDesc[5])
            {
            }
            column(chargeDesc6;chargeDesc[6])
            {
            }
            column(chargeDesc7;chargeDesc[7])
            {
            }
            column(chargeDesc8;chargeDesc[8])
            {
            }
            column(chargeDesc9;chargeDesc[9])
            {
            }
            column(chargeDesc10;chargeDesc[10])
            {
            }
            column(chargeDesc11;chargeDesc[11])
            {
            }
            column(chargeDesc12;chargeDesc[12])
            {
            }
            column(chargeDesc13;chargeDesc[13])
            {
            }
            column(ChargeAmount1;ChargeAmount[1])
            {
            }
            column(ChargeAmount2;ChargeAmount[2])
            {
            }
            column(ChargeAmount3;ChargeAmount[3])
            {
            }
            column(ChargeAmount4;ChargeAmount[4])
            {
            }
            column(ChargeAmount5;ChargeAmount[5])
            {
            }
            column(ChargeAmount6;ChargeAmount[6])
            {
            }
            column(ChargeAmount7;ChargeAmount[7])
            {
            }
            column(ChargeAmount8;ChargeAmount[8])
            {
            }
            column(ChargeAmount9;ChargeAmount[9])
            {
            }
            column(ChargeAmount10;ChargeAmount[10])
            {
            }
            column(ChargeAmount11;ChargeAmount[11])
            {
            }
            column(ChargeAmount12;ChargeAmount[12])
            {
            }
            column(ChargeAmount13;ChargeAmount[13])
            {
            }
            column(ChargeTotal;ChargeTotal)
            {
            }

            trigger OnAfterGetRecord()
            var
                TTTT: Text[30];
            begin
                   if applicSet.Get() then begin
                   end;
                    Clear(ttl);
                   Clear(repEndDate);
                   if Gender=Gender::Male then ttl:='MR. ' else ttl:='MRS/MISS';
                    FullNames:="ACA-Applic. Form Header".Surname+' '+"ACA-Applic. Form Header"."Other Names";
                   ProgName:='';
                   if Prog.Get("ACA-Applic. Form Header"."First Degree Choice") then
                   ProgName:=Prog.Description;

                   if IntakeRec.Get("ACA-Applic. Form Header"."Intake Code") then begin
                    IntakeRec.TestField(IntakeRec."Reporting Date");
                    ReportDate:= Format(IntakeRec."Reporting Date",0,'<Day> <Month Text>') +' '+Format(Date2dmy(IntakeRec."Reporting Date",3));
                    repEndDate:= Format(IntakeRec."Reporting End Date",0,'<Day> <Month Text>') +' '+Format(Date2dmy(IntakeRec."Reporting End Date",3));
                   end;
                   DateStr:= Format(Today,0,'<Day> <Month Text>') +' '+Format(Date2dmy(Today,3));

                    FacultyName:='';
                    FacRec.Reset;
                   // FacRec.SETRANGE(FacRec.Code,"ACA-Adm. Form Header"."Faculty Admitted To");
                    if FacRec.Find('-') then
                    FacultyName:=FacRec.Name;

                if "ACA-Applic. Form Header"."First Choice Stage" = 'Y1S1' then YearName:='Year 1 Semester 1'  else if
                   "ACA-Applic. Form Header"."First Choice Stage" = 'Y2S1' then YearName:='Second Year First Semester' else if
                   "ACA-Applic. Form Header"."First Choice Stage" = 'Y3S1' then YearName:='Third Year First Semester' else if
                   "ACA-Applic. Form Header"."First Choice Stage" = 'Y2S1' then YearName:='Fourth Year First Semester' ;
            end;

            trigger OnPreDataItem()
            begin
                  if CompInfo.Get then
                   CompName:=CompInfo.Name;
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
        CompName: Text[50];
        ReportDate: Text;
        FullNames: Text[100];
        ProgName: Code[100];
        Prog: Record UnknownRecord61511;
        IntakeRec: Record UnknownRecord61383;
        ComenceDate: Date;
        DateStr: Text[50];
        FacultyName: Text[100];
        FacRec: Record "Dimension Value";
        CompInfo: Record "Company Information";
        YearName: Text[50];
        ttl: Text;
        repEndDate: Text;
        applicSet: Record UnknownRecord61367;
        FeeByStage: Record UnknownRecord61523;
        progCharges: Record UnknownRecord61533;
        counted: Integer;
        counted2: array [13] of Integer;
        chargeDesc: array [13] of Code[50];
        ChargeAmount: array [13] of Decimal;
        ChargeTotal: Decimal;
        ProgCategory: Code[100];
        applic: Record UnknownRecord61358;
        title: Code[10];
}

