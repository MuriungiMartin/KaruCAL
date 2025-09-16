#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51829 "Employee Details Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Employee Details Summary.rdlc';

    dataset
    {
        dataitem(UnknownTable61188;UnknownTable61188)
        {
            RequestFilterFields = "No.";
            column(ReportForNavId_1000000001; 1000000001)
            {
            }
            column(logo;info.Picture)
            {
            }
            column(CoName;info.Name)
            {
            }
            column(CoAddress;info.Address)
            {
            }
            column(CoCity;info.City)
            {
            }
            column(CoPhone;info."Phone No.")
            {
            }
            column(CoEmail;info."E-Mail")
            {
            }
            column(HomePage;info."Home Page")
            {
            }
            column(Pf_No;"HRM-Employee C"."No.")
            {
            }
            column(Title;"HRM-Employee C".Title)
            {
            }
            column(FName;"HRM-Employee C"."First Name"+' '+"HRM-Employee C"."Middle Name"+' '+"HRM-Employee C"."Last Name")
            {
            }
            column(EmpTelephone;"HRM-Employee C"."Cellular Phone Number")
            {
            }
            column(Status;"HRM-Employee C".Status)
            {
            }
            column(IdNo;"HRM-Employee C"."ID Number")
            {
            }
            column(Gender;"HRM-Employee C".Gender)
            {
            }
            column(Tribe;"HRM-Employee C".Tribe)
            {
            }
            column(Disabled;"HRM-Employee C".Disabled)
            {
            }
            column(DOB;"HRM-Employee C"."Date Of Birth")
            {
            }
            column(DOJ;"HRM-Employee C"."Date Of Join")
            {
            }
            column(EmpAge;"HRM-Employee C".Age)
            {
            }
            column(LOS;"HRM-Employee C"."Length Of Service")
            {
            }
            column(Telephone;"HRM-Employee C"."Home Phone Number")
            {
            }
            column(Cell;"HRM-Employee C"."Cellular Phone Number")
            {
            }
            column(Extension;"HRM-Employee C"."Ext.")
            {
            }
            column(Address;"HRM-Employee C"."Postal Address")
            {
            }
            column(Email;"HRM-Employee C"."E-Mail")
            {
            }
            column(EMail2;"HRM-Employee C"."Company E-Mail")
            {
            }
            column(Department;"HRM-Employee C"."Department Code")
            {
            }
            column(Section;"HRM-Employee C"."Section Code")
            {
            }
            column(PIN;"HRM-Employee C"."PIN Number")
            {
            }
            column(NSSF;"HRM-Employee C"."NSSF No.")
            {
            }
            column(NHIF;"HRM-Employee C"."NHIF No.")
            {
            }
            column(HELB;"HRM-Employee C"."HELB No")
            {
            }
            column(CooperateNo;"HRM-Employee C"."Co-Operative No")
            {
            }
            column(PayrollNo;"HRM-Employee C"."PAYROLL NO")
            {
            }
            dataitem(NxtOfKin;UnknownTable61323)
            {
                DataItemLink = "Employee Code"=field("No.");
                DataItemTableView = where(Type=filter("Next of Kin"));
                PrintOnlyIfDetail = false;
                column(ReportForNavId_1000000035; 1000000035)
                {
                }
                column(shownextofkin;shownextofkin)
                {
                }
                column(KinRelationship;NxtOfKin.Relationship)
                {
                }
                column(KinSurName;NxtOfKin.SurName)
                {
                }
                column(KinOtherNames;NxtOfKin."Other Names")
                {
                }
                column(KinId;NxtOfKin."ID No/Passport No")
                {
                }
                column(KinPhone;NxtOfKin."Home Tel No")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    shownextofkin:=true;
                    if NxtOfKin.Relationship='' then shownextofkin:=false;
                end;
            }
            dataitem(Beneficiaries;UnknownTable61324)
            {
                DataItemLink = "Employee Code"=field("No.");
                column(ReportForNavId_1000000046; 1000000046)
                {
                }
                column(showBeneficiery;showBeneficiery)
                {
                }
                column(BenRelationship;Beneficiaries.Relationship)
                {
                }
                column(BenSurname;Beneficiaries.SurName)
                {
                }
                column(BenOtherNames;Beneficiaries."Other Names")
                {
                }
                column(BenID;Beneficiaries."ID No/Passport No")
                {
                }
                column(BenPhone;Beneficiaries."Home Tel No")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    showBeneficiery:=true;
                    if Beneficiaries.Relationship='' then showBeneficiery:=false;
                end;
            }
            dataitem(Dependants;UnknownTable61323)
            {
                DataItemLink = "Employee Code"=field("No.");
                DataItemTableView = where(Type=filter(Dependant));
                column(ReportForNavId_1000000052; 1000000052)
                {
                }
                column(showDependants;showDependants)
                {
                }
                column(DependantsRela;Dependants.Relationship)
                {
                }
                column(DependantsSurname;Dependants.SurName)
                {
                }
                column(DependantsOtherNames;Dependants."Other Names")
                {
                }
                column(DependantsID;Dependants."ID No/Passport No")
                {
                }
                column(DependantsPhone;Dependants."Home Tel No")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    showDependants:=true;
                    if Dependants.Relationship='' then showDependants:=false;
                end;
            }
            dataitem(EmpQualifications;"Employee Qualification")
            {
                DataItemLink = "Employee No."=field("No.");
                column(ReportForNavId_1000000058; 1000000058)
                {
                }
                column(showQualif;showQualif)
                {
                }
                column(qualific;EmpQualifications."Qualification Code")
                {
                }
                column(QualType;EmpQualifications.Type)
                {
                }
                column(QualFrom;EmpQualifications."From Date")
                {
                }
                column(QualTo;EmpQualifications."To Date")
                {
                }
                column(QualInst;EmpQualifications."Institution/Company")
                {
                }
                column(QualDescrip;EmpQualifications.Qualification)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    showQualif:=true;
                    if EmpQualifications.Description='' then showQualif:=false;
                end;
            }
            dataitem(EmploymentHistory;UnknownTable61214)
            {
                DataItemLink = "Employee No."=field("No.");
                column(ReportForNavId_1000000064; 1000000064)
                {
                }
                column(showEmployHist;showEmployHist)
                {
                }
                column(EmpHistCompany;EmploymentHistory."Company Name")
                {
                }
                column(EmpHistFrom;EmploymentHistory.From)
                {
                }
                column(EmpHistTo;EmploymentHistory."To Date")
                {
                }
                column(EmpHistTitle;EmploymentHistory."Job Title")
                {
                }
                column(EmpHistSalary;EmploymentHistory."Salary On Leaving")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    showEmployHist:=true;
                    if EmploymentHistory."Company Name"='' then showEmployHist:=false;
                end;
            }
            dataitem(ProfMembership;UnknownTable61194)
            {
                DataItemLink = "Employee Code"=field("No.");
                column(ReportForNavId_1000000070; 1000000070)
                {
                }
                column(showProfMemberShip;showProfMemberShip)
                {
                }
                column(MembershipNo;ProfMembership."Membership No")
                {
                }
                column(MembershipNameOfBody;ProfMembership."Name of Body")
                {
                }
                column(MembershipDate;ProfMembership."Date of Membership")
                {
                }
                column(MembershipStatus;ProfMembership."Membership Status")
                {
                }
                column(MembershipRemarks;ProfMembership.Remarks)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    showProfMemberShip:=true;
                    if ProfMembership."Membership No"='' then showProfMemberShip:=false;
                end;
            }
            dataitem(TrainingHistory;UnknownTable61216)
            {
                DataItemLink = "Employee No."=field("No.");
                column(ReportForNavId_1000000076; 1000000076)
                {
                }
                column(showTrainHist;showTrainHist)
                {
                }
                column(TrainAppcationNo;TrainingHistory."Application No")
                {
                }
                column(TrainCourseTitle;TrainingHistory."Course Title")
                {
                }
                column(TrainFromDate;TrainingHistory."From Date")
                {
                }
                column(TrainToDate;TrainingHistory."To Date")
                {
                }
                column(TrainingDuration;TrainingHistory.Duration)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    showTrainHist:=true;
                    if TrainingHistory."Application No"='' then showTrainHist:=false;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                seq:=seq+1;
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
        if info.Get() then begin
            info.CalcFields(info.Picture);
          end;
    end;

    var
        info: Record "Company Information";
        seq: Integer;
        shownextofkin: Boolean;
        showBeneficiery: Boolean;
        showDependants: Boolean;
        showQualif: Boolean;
        showEmployHist: Boolean;
        showProfMemberShip: Boolean;
        showTrainHist: Boolean;
}

