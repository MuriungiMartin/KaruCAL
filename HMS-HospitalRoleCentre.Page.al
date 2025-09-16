#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68194 "HMS-Hospital Role Centre"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control10)
            {
                part(Control8;"HMS-Cue")
                {
                    Caption = 'HMS CUE';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Review)
            {
                Caption = 'Review';
                Image = Payables;
                action(EmployeeDeps)
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Dependants';
                    Image = CompareContacts;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "HMIS-Employees Listing";
                }
            }
            group(Admissions)
            {
                Caption = 'Admissions';
                Image = Payables;
                action("Process Registered Students")
                {
                    ApplicationArea = Basic;
                    RunObject = Report "HMS Process Registered Student";
                }
                action(AdmReq)
                {
                    ApplicationArea = Basic;
                    Caption = 'Admission Requests';
                    Image = FixedAssets;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "HMS Admission Form Header";
                }
                action(AdmProg)
                {
                    ApplicationArea = Basic;
                    Caption = 'Admission Process';
                    Image = FixedAssetLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Admission Progress";
                }
                action("Academic Year")
                {
                    ApplicationArea = Basic;
                    Image = Calendar;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "ACA-Academic Year List";
                }
            }
            group(Referrals)
            {
                Caption = 'Referrals';
                Image = Confirm;
                action(RefHosp)
                {
                    ApplicationArea = Basic;
                    Caption = 'Referral Hospitals';
                    Image = SetupColumns;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Vendor Card";
                }
                action(ActiveRef)
                {
                    ApplicationArea = Basic;
                    Caption = 'Active Referrals';
                    Image = Setup;
                    Promoted = true;
                    RunObject = Page "HMS Referral Header Active";
                }
                action(hitRef)
                {
                    ApplicationArea = Basic;
                    Caption = 'Completed Referrals';
                    Image = Employee;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Referral Header Released";
                }
            }
            group(Immunizations)
            {
                Caption = 'Immunizations';
                Image = SNInfo;
                action(Immunization)
                {
                    ApplicationArea = Basic;
                    Image = NewOrder;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "HMS Immunization Header";
                }
                action(ImmHist)
                {
                    ApplicationArea = Basic;
                    Caption = 'Immunization History';
                    Image = History;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "HMS Immunization Posted";
                }
            }
            group("Stock take")
            {
                Caption = 'Stock take';
                action("Stock take Process")
                {
                    ApplicationArea = Basic;
                    Caption = 'Stock take Process';
                    Image = PaymentForecast;
                    Promoted = true;
                    RunObject = Page "Phys. Inventory Journal";
                }
            }
            group(Reports)
            {
                Caption = 'HMS Reports';
                Image = SNInfo;
                action(Results)
                {
                    ApplicationArea = Basic;
                    Caption = 'Lab results';
                    Image = AddToHome;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report Labreport;
                }
                action(App)
                {
                    ApplicationArea = Basic;
                    Caption = 'Appointments';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "HMS Appointments Listing";
                }
                action(Observ)
                {
                    ApplicationArea = Basic;
                    Caption = 'Observations';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "HMS Observation Listing Report";
                }
                action(treatment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Treatments';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "Hms Treatment   List";
                }
                action(labtest1)
                {
                    ApplicationArea = Basic;
                    Caption = 'Lab Tests Summary';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "HMS Laboratory Test Summary";
                }
                action(labtest2)
                {
                    ApplicationArea = Basic;
                    Caption = 'Lab Tests Detailed';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "HMS Laboratory Test Detailed";
                }
                action(labtest3)
                {
                    ApplicationArea = Basic;
                    Caption = 'Lab tests Findings';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "HMS Laboratory Test Finding";
                }
                action(pham_Drug_1)
                {
                    ApplicationArea = Basic;
                    Caption = 'Process Student Patients';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "HMS Pharmacy Issues Report";
                }
                action(PatList)
                {
                    ApplicationArea = Basic;
                    Caption = 'Patient listing';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "HMS Patient Listing Report";
                }
                action(Admission_List)
                {
                    ApplicationArea = Basic;
                    Caption = 'Admission listing';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "HMS Admission Listing Summary";
                }
                action(Ref_list)
                {
                    ApplicationArea = Basic;
                    Caption = 'Referrals Listing';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "HMS Referral Listing Report";
                }
                action(Daily_Att_OutPat)
                {
                    ApplicationArea = Basic;
                    Caption = 'Daily Attendance (Outpatient)';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "HMS Daily Attendance Report";
                }
                action(Inj_Reg)
                {
                    ApplicationArea = Basic;
                    Caption = 'Injection Register';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "HMS Injection Register Report";
                }
                action(Proc_Emp_and_Deps)
                {
                    ApplicationArea = Basic;
                    Caption = 'Appointments';
                    Image = ExecuteAndPostBatch;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "HMS Process Employee & Deps";
                }
                action(Proc_Stud_Patient)
                {
                    ApplicationArea = Basic;
                    Caption = 'Appointments';
                    Image = ExecuteBatch;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "Process Student Patients";
                }
                action("Diagnosis Report")
                {
                    ApplicationArea = Basic;
                    Caption = 'Diagnosis Report';
                    Image = AddAction;
                    Promoted = true;
                    RunObject = Report "HMS-Diagnosis";
                }
                action("Drugs Stock")
                {
                    ApplicationArea = Basic;
                    Caption = 'Drugs Stock';
                    Image = AddWatch;
                    Promoted = true;
                    RunObject = Report "Stock Summary Clinic";
                }
            }
            group(Beneficiaries)
            {
                Caption = 'Beneficiaries Report';
                Image = SNInfo;
                action("Employee Beneficiaries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Beneficiaries';
                    Image = AddToHome;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "HR Employee Beneficiaries";
                }
            }
            group(Setups)
            {
                Caption = 'Hospital Setups';
                Image = SNInfo;
                action(Ob_signs)
                {
                    ApplicationArea = Basic;
                    Caption = 'Observation Signs';
                    Image = Opportunity;
                    Promoted = true;
                    PromotedIsBig = false;
                    RunObject = Page "HMS Observation Signs";
                }
                action(ImmunHist)
                {
                    ApplicationArea = Basic;
                    Caption = 'Immunization History';
                    Image = History;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "HMS Immunization Posted";
                }
                action(Setup)
                {
                    ApplicationArea = Basic;
                    Caption = 'Setup Card';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS-Setup Card";
                }
                action(Systems_Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Systems Card';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS-Systems Card";
                }
                action(Setup_Doctor)
                {
                    ApplicationArea = Basic;
                    Caption = 'Setup Doctor';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS-Setup Doctor Card";
                }
                action(Setup_Blood_Group)
                {
                    ApplicationArea = Basic;
                    Caption = 'Setup Blood Group';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS-Setup Blood Group Card";
                }
                action(Blood_Group_Donation)
                {
                    ApplicationArea = Basic;
                    Caption = 'Blood Group Donation';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS-Blood Group Donation Card";
                }
                action(Drug_Interaction)
                {
                    ApplicationArea = Basic;
                    Caption = 'Drug Interaction';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Drug Interaction Header";
                }
                action(Observation_Signs)
                {
                    ApplicationArea = Basic;
                    Caption = 'Observation Signs';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Observation Signs";
                }
                action(Appointment_Typ)
                {
                    ApplicationArea = Basic;
                    Caption = 'Appointment Type';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS-Setup Appointment Typ Card";
                }
                action(Triage)
                {
                    ApplicationArea = Basic;
                    Caption = 'Triage Tests Setup';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "CAT-Catering Ledger";
                }
                action("Setup Process")
                {
                    ApplicationArea = Basic;
                    Caption = 'Process Setup';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS-Setup Process Card";
                }
                action(Injection)
                {
                    ApplicationArea = Basic;
                    Caption = 'Injection';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS-Setup Injection Card";
                }
                action(Diagnosis)
                {
                    ApplicationArea = Basic;
                    Caption = 'Diagnosis';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS-Setup Diagnosis Card";
                }
                action(Allergy)
                {
                    ApplicationArea = Basic;
                    Caption = 'Allergy';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS-Setup Allergy Card";
                }
                action(signs)
                {
                    ApplicationArea = Basic;
                    Caption = 'Signs';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Signs";
                }
                action(Symptoms)
                {
                    ApplicationArea = Basic;
                    Caption = 'Symptoms';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Syptoms";
                }
                action(messuring_Uni)
                {
                    ApplicationArea = Basic;
                    Caption = 'Measuring Units';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS-Setup Measuring Unit Card";
                }
                action(specimen)
                {
                    ApplicationArea = Basic;
                    Caption = 'Specimen Card';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS-Setup Specimen Card";
                }
                action(Lab_test)
                {
                    ApplicationArea = Basic;
                    Caption = 'Lab Test Setups';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS-Setup Lab Test Card";
                }
                action(Rad_Types)
                {
                    ApplicationArea = Basic;
                    Caption = 'Radiology Types';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS-Setup Radiology Type Card";
                }
                action(Setup_Disctarge_Process)
                {
                    ApplicationArea = Basic;
                    Caption = 'Setup Disctarge Process';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Setup Disctarge Process";
                }
                action(wards)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ward Setup';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS ward Setup";
                }
                action(Beds)
                {
                    ApplicationArea = Basic;
                    Caption = 'Beds';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Beds";
                }
                action(Hos_Charges)
                {
                    ApplicationArea = Basic;
                    Caption = 'Hospital Charges Setup';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS-Hospital Charges Setup";
                }
            }
        }
        area(sections)
        {
            group(Registration)
            {
                action("Patients List")
                {
                    ApplicationArea = Basic;
                    Image = Register;
                    Promoted = true;
                    RunObject = Page "HMS-Patient List";
                }
            }
            group(Appointments)
            {
                Caption = 'Appointments';
                Image = Statistics;
                action(Action19)
                {
                    ApplicationArea = Basic;
                    Caption = 'Appointments';
                    Image = Register;
                    Promoted = true;
                    RunObject = Page "HMS-Appointment List";
                }
                action("Appointments Control")
                {
                    ApplicationArea = Basic;
                    Caption = 'Appointments Control';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "HMS-Appointment Form List2";
                }
                action("Appointments History")
                {
                    ApplicationArea = Basic;
                    Caption = 'Appointments History';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "HMS-Appointment Form History L";
                }
            }
            group(ObsRoom)
            {
                Caption = 'Observation Room';
                Image = RegisteredDocs;
                action(Observations)
                {
                    ApplicationArea = Basic;
                    Caption = 'Observations';
                    RunObject = Page "HMS-Observations List";
                }
                action("Observation History")
                {
                    ApplicationArea = Basic;
                    Caption = 'Observation History';
                    RunObject = Page "HMS-Observation History List";
                }
            }
            group(DocVisit)
            {
                Caption = 'Consultation Room';
                Image = Journals;
                action(DocVisits)
                {
                    ApplicationArea = Basic;
                    Caption = 'Doctor''s Visits';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;
                    RunObject = Page "HMS-Treatment List";
                }
                action("Doctor's Visit History")
                {
                    ApplicationArea = Basic;
                    Caption = 'Doctor''s Visit History';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "HMS-Treatment History List";
                }
            }
            group(Lab)
            {
                Caption = 'Lab. Visits';
                Image = FiledPosted;
                action(Lab_List)
                {
                    ApplicationArea = Basic;
                    Caption = 'Test Requests';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "HMS Laboratory List";
                }
                action(findings)
                {
                    ApplicationArea = Basic;
                    Caption = 'Test Findings';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "HMS-Laboratory Form List 2";
                }
                action(Hist)
                {
                    ApplicationArea = Basic;
                    Caption = 'Doctor''s Visit History';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "HMS-Lab Form History Li";
                }
            }
            group(Pharmacy)
            {
                Caption = 'Pharmacy';
                Image = Departments;
                action(Pharm)
                {
                    ApplicationArea = Basic;
                    Caption = 'Pharmacy List';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;
                    RunObject = Page "HMS Pharmacy List";
                }
                action(Pharm_Hist)
                {
                    ApplicationArea = Basic;
                    Caption = 'Pharmacy History';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "HMS-Treatment Form List 2";
                }
                action("Posted Pharmacy List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Pharmacy List';
                    RunObject = Page "HMS-Pharmacy Posted";
                }
                action("Drug List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Drug List';
                    RunObject = Page "Drug List";
                }
            }
            group(HMS_Admissions)
            {
                Caption = 'Admissions';
                Image = LotInfo;
                action(Pat_Admissions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Patient Admissions';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;
                    RunObject = Page "HMS-Admission Form Header List";
                }
                action("Admission Progress")
                {
                    ApplicationArea = Basic;
                    Caption = 'Admission Progress';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "HMS-Admission Progress List";
                }
            }
            group(Refs)
            {
                Caption = 'Referrals';
                Image = RegisteredDocs;
                action(ref)
                {
                    ApplicationArea = Basic;
                    Caption = 'Referrals';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;
                    RunObject = Page "HMS-Referral Header List";
                }
                action(ref_Hist)
                {
                    ApplicationArea = Basic;
                    Caption = 'Referrals History';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "HMS-Referral Header List2";
                }
                action("Referal Requests")
                {
                    ApplicationArea = Basic;
                    Caption = 'Referal Requests';
                    RunObject = Page "Hms Referal List";
                }
                action("Staff Referral")
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff Referral';
                    RunObject = Page "Hms Referal List";
                }
            }
            group(Immuns)
            {
                Caption = 'Immunizations';
                Image = ReferenceData;
                action(Immun)
                {
                    ApplicationArea = Basic;
                    Caption = 'Immunizations';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;
                    RunObject = Page "HMS-Immunization Header List";
                }
                action(Immun_History)
                {
                    ApplicationArea = Basic;
                    Caption = 'Immunizations History';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "HMS-Immunization Posted List";
                }
            }
            group(Sickoff)
            {
                Caption = 'Sickoff';
                Image = ReferenceData;
                action(Offduty)
                {
                    ApplicationArea = Basic;
                    Caption = 'Off Duty';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;
                    RunObject = Page "HMS Off Duty";
                }
            }
            group(Billing)
            {
                Caption = 'Hospital Billing';
                Image = Intrastat;
                action("Patient Billing")
                {
                    ApplicationArea = Basic;
                    Caption = 'Patient Billing';
                    Image = Insurance;
                    Promoted = true;
                    RunObject = Page "HMS-Patient Billing";
                }
                action(Hospital_Customer_List)
                {
                    ApplicationArea = Basic;
                    Caption = 'Hospital Customer List';
                    RunObject = Page "HMS-Customers List";
                }
            }
            group(Approvals)
            {
                Caption = 'Approvals';
                Image = Alerts;
                action("Pending My Approval")
                {
                    ApplicationArea = Basic;
                    Caption = 'Pending My Approval';
                    RunObject = Page "Approval Entries";
                }
                action("My Approval requests")
                {
                    ApplicationArea = Basic;
                    Caption = 'My Approval requests';
                    RunObject = Page "Approval Request Entries";
                }
                action("Clearance Requests")
                {
                    ApplicationArea = Basic;
                    Caption = 'Clearance Requests';
                    RunObject = Page "ACA-Clearance Approval Entries";
                }
            }
            group(Common_req)
            {
                Caption = 'Common Requisitions';
                Image = LotInfo;
                action("Stores Requisitions")
                {
                    ApplicationArea = Basic;
                    Caption = 'Stores Requisitions';
                    RunObject = Page "PROC-Store Requisition";
                }
                action("Imprest Requisitions")
                {
                    ApplicationArea = Basic;
                    Caption = 'Imprest Requisitions';
                    RunObject = Page "FIN-Imprest List UP";
                }
                action("Leave Applications")
                {
                    ApplicationArea = Basic;
                    Caption = 'Leave Applications';
                    RunObject = Page "HRM-Leave Requisition List";
                }
                action("My Approved Leaves")
                {
                    ApplicationArea = Basic;
                    Caption = 'My Approved Leaves';
                    Image = History;
                    RunObject = Page "HRM-My Approved Leaves List";
                }
                action("File Requisitions")
                {
                    ApplicationArea = Basic;
                    Image = Register;
                    Promoted = true;
                    RunObject = Page "REG-File Requisition List";
                }
                action("Meal Booking")
                {
                    ApplicationArea = Basic;
                    Caption = 'Meal Booking';
                    RunObject = Page "CAT-Meal Booking List";
                }
            }
        }
    }
}

