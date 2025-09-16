#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51698 "Consolidated Marksheet 2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Consolidated Marksheet 2.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = sorting("Student No.") order(ascending) where("Units Taken"=filter(>0),Reversed=const(No),Blocked=const(0),"Register for"=const(Stage),"Cust Exist"=filter(>0));
            RequestFilterFields = "Year Of Study","Academic Year","Programme Filter","Stage Filter","Semester Filter",Semester,"Student No.",Session,"Campus Filter","Settlement Type","Options Filter";
            column(ReportForNavId_2901; 2901)
            {
            }
            column(SemYear;SemYear)
            {
            }
            column(Course_Registration__GETFILTER__Course_Registration___Stage_Filter__;"ACA-Course Registration".GetFilter("ACA-Course Registration"."Stage Filter"))
            {
            }
            column(PName;PName)
            {
            }
            column(Dept;Dept)
            {
            }
            column(FDesc;FDesc)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(Page_No_____FORMAT_CurrReport_PAGENO_;'Page No.  '+Format(CurrReport.PageNo))
            {
            }
            column(Course_Registration__GETFILTER__Course_Registration___Semester_Filter__;"ACA-Course Registration".GetFilter("ACA-Course Registration"."Semester Filter"))
            {
            }
            column(Course_Registration__GETFILTER_Options_;"ACA-Course Registration".GetFilter(Options))
            {
            }
            column(ColumnH_1_;ColumnH[1])
            {
            }
            column(ColumnH_8_;ColumnH[8])
            {
            }
            column(ColumnH_6_;ColumnH[6])
            {
            }
            column(ColumnH_7_;ColumnH[7])
            {
            }
            column(ColumnH_4_;ColumnH[4])
            {
            }
            column(ColumnH_3_;ColumnH[3])
            {
            }
            column(ColumnH_5_;ColumnH[5])
            {
            }
            column(ColumnH_2_;ColumnH[2])
            {
            }
            column(ColumnH_15_;ColumnH[15])
            {
            }
            column(ColumnH_14_;ColumnH[14])
            {
            }
            column(ColumnH_13_;ColumnH[13])
            {
            }
            column(ColumnH_12_;ColumnH[12])
            {
            }
            column(ColumnH_10_;ColumnH[10])
            {
            }
            column(ColumnH_9_;ColumnH[9])
            {
            }
            column(ColumnH_11_;ColumnH[11])
            {
            }
            column(ColumnH_23_;ColumnH[23])
            {
            }
            column(ColumnH_22_;ColumnH[22])
            {
            }
            column(ColumnH_21_;ColumnH[21])
            {
            }
            column(ColumnH_20_;ColumnH[20])
            {
            }
            column(ColumnH_19_;ColumnH[19])
            {
            }
            column(ColumnH_18_;ColumnH[18])
            {
            }
            column(ColumnH_17_;ColumnH[17])
            {
            }
            column(ColumnH_16_;ColumnH[16])
            {
            }
            column(uColumnV_1_;uColumnV[1])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_2_;uColumnV[2])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_3_;uColumnV[3])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_4_;uColumnV[4])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_5_;uColumnV[5])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_6_;uColumnV[6])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_7_;uColumnV[7])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_8_;uColumnV[8])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_9_;uColumnV[9])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_10_;uColumnV[10])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_11_;uColumnV[11])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_12_;uColumnV[12])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_13_;uColumnV[13])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_14_;uColumnV[14])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_15_;uColumnV[15])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_16_;uColumnV[16])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_17_;uColumnV[17])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_18_;uColumnV[18])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_19_;uColumnV[19])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_20_;uColumnV[20])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_21_;uColumnV[21])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_22_;uColumnV[22])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_23_;uColumnV[23])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_30_;uColumnV[30])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_29_;uColumnV[29])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_28_;uColumnV[28])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_26_;ColumnH[26])
            {
            }
            column(ColumnH_30_;ColumnH[30])
            {
            }
            column(ColumnH_29_;ColumnH[29])
            {
            }
            column(ColumnH_28_;ColumnH[28])
            {
            }
            column(uColumnV_27_;uColumnV[27])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_27_;ColumnH[27])
            {
            }
            column(uColumnV_26_;uColumnV[26])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_25_;ColumnH[25])
            {
            }
            column(uColumnV_25_;uColumnV[25])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_24_;ColumnH[24])
            {
            }
            column(uColumnV_24_;uColumnV[24])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_31_;ColumnH[31])
            {
            }
            column(ColumnH_40_;ColumnH[40])
            {
            }
            column(ColumnH_39_;ColumnH[39])
            {
            }
            column(ColumnH_38_;ColumnH[38])
            {
            }
            column(ColumnH_37_;ColumnH[37])
            {
            }
            column(uColumnV_40_;uColumnV[40])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_39_;uColumnV[39])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_38_;uColumnV[38])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_37_;uColumnV[37])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_36_;ColumnH[36])
            {
            }
            column(uColumnV_36_;uColumnV[36])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_35_;ColumnH[35])
            {
            }
            column(uColumnV_35_;uColumnV[35])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_34_;ColumnH[34])
            {
            }
            column(uColumnV_34_;uColumnV[34])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_33_;ColumnH[33])
            {
            }
            column(uColumnV_33_;uColumnV[33])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_32_;ColumnH[32])
            {
            }
            column(uColumnV_32_;uColumnV[32])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_31_;uColumnV[31])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_41_;ColumnH[41])
            {
            }
            column(ColumnH_50_;ColumnH[50])
            {
            }
            column(ColumnH_49_;ColumnH[49])
            {
            }
            column(ColumnH_48_;ColumnH[48])
            {
            }
            column(ColumnH_47_;ColumnH[47])
            {
            }
            column(uColumnV_50_;uColumnV[50])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_49_;uColumnV[49])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_48_;uColumnV[48])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_47_;uColumnV[47])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_46_;ColumnH[46])
            {
            }
            column(uColumnV_46_;uColumnV[46])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_25__Control1102755076;ColumnH[25])
            {
            }
            column(uColumnV_45_;uColumnV[45])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_44_;ColumnH[44])
            {
            }
            column(uColumnV_44_;uColumnV[44])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_43_;ColumnH[43])
            {
            }
            column(uColumnV_43_;uColumnV[43])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_42_;ColumnH[42])
            {
            }
            column(uColumnV_42_;uColumnV[42])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_41_;uColumnV[41])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_51_;ColumnH[51])
            {
            }
            column(ColumnH_60_;ColumnH[60])
            {
            }
            column(ColumnH_59_;ColumnH[59])
            {
            }
            column(ColumnH_58_;ColumnH[58])
            {
            }
            column(ColumnH_57_;ColumnH[57])
            {
            }
            column(uColumnV_60_;uColumnV[60])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_59_;uColumnV[59])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_58_;uColumnV[58])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_57_;uColumnV[57])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_56_;ColumnH[56])
            {
            }
            column(uColumnV_56_;uColumnV[56])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_55_;ColumnH[55])
            {
            }
            column(uColumnV_55_;uColumnV[55])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_54_;ColumnH[54])
            {
            }
            column(uColumnV_54_;uColumnV[54])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_53_;ColumnH[53])
            {
            }
            column(uColumnV_53_;uColumnV[53])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_22__Control1102755102;ColumnH[22])
            {
            }
            column(uColumnV_52_;uColumnV[52])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_51_;uColumnV[51])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_66_;ColumnH[66])
            {
            }
            column(uColumnV_66_;uColumnV[66])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_65_;ColumnH[65])
            {
            }
            column(uColumnV_65_;uColumnV[65])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_64_;ColumnH[64])
            {
            }
            column(uColumnV_64_;uColumnV[64])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_63_;ColumnH[63])
            {
            }
            column(uColumnV_63_;uColumnV[63])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_62_;ColumnH[62])
            {
            }
            column(uColumnV_62_;uColumnV[62])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_61_;ColumnH[61])
            {
            }
            column(uColumnV_61_;uColumnV[61])
            {
                DecimalPlaces = 0:0;
            }
            column(Course_Registration__Course_Registration___Student_No__;"ACA-Course Registration"."Student No.")
            {
            }
            column(Cust_Name;Cust.Name)
            {
            }
            column(ColumnV_1_;ColumnV[1])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_8_;ColumnV[8])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_7_;ColumnV[7])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_6_;ColumnV[6])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_5_;ColumnV[5])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_4_;ColumnV[4])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_3_;ColumnV[3])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_2_;ColumnV[2])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_14_;ColumnV[14])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_13_;ColumnV[13])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_12_;ColumnV[12])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_11_;ColumnV[11])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_10_;ColumnV[10])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_9_;ColumnV[9])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_23_;ColumnV[23])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_22_;ColumnV[22])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_21_;ColumnV[21])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_20_;ColumnV[20])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_19_;ColumnV[19])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_18_;ColumnV[18])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_17_;ColumnV[17])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_16_;ColumnV[16])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_15_;ColumnV[15])
            {
                DecimalPlaces = 0:0;
            }
            column(SCount;SCount)
            {
            }
            column(ColumnV_30_;ColumnV[30])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_29_;ColumnV[29])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_28_;ColumnV[28])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_27_;ColumnV[27])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_26_;ColumnV[26])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_25_;ColumnV[25])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_24_;ColumnV[24])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_60_;ColumnV[60])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_59_;ColumnV[59])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_58_;ColumnV[58])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_57_;ColumnV[57])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_56_;ColumnV[56])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_55_;ColumnV[55])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_54_;ColumnV[54])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_53_;ColumnV[53])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_52_;ColumnV[52])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_51_;ColumnV[51])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_50_;ColumnV[50])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_49_;ColumnV[49])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_48_;ColumnV[48])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_47_;ColumnV[47])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_46_;ColumnV[46])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_45_;ColumnV[45])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_44_;ColumnV[44])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_43_;ColumnV[43])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_42_;ColumnV[42])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_41_;ColumnV[41])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_40_;ColumnV[40])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_39_;ColumnV[39])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_38_;ColumnV[38])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_37_;ColumnV[37])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_36_;ColumnV[36])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_35_;ColumnV[35])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_34_;ColumnV[34])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_33_;ColumnV[33])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_32_;ColumnV[32])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_31_;ColumnV[31])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_65_;ColumnV[65])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_64_;ColumnV[64])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_63_;ColumnV[63])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_62_;ColumnV[62])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_61_;ColumnV[61])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_66_;ColumnV[66])
            {
                DecimalPlaces = 0:0;
            }
            column(TReg;TReg)
            {
            }
            column(SMM_1_;SMM[1])
            {
            }
            column(ColumnVA_1_;ColumnVA[1])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_2_;ColumnVA[2])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_3_;ColumnVA[3])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_4_;ColumnVA[4])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_5_;ColumnVA[5])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_6_;ColumnVA[6])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_7_;ColumnVA[7])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_8_;ColumnVA[8])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_9_;ColumnVA[9])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_10_;ColumnVA[10])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_11_;ColumnVA[11])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_12_;ColumnVA[12])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_13_;ColumnVA[13])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_14_;ColumnVA[14])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_15_;ColumnVA[15])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_16_;ColumnVA[16])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_17_;ColumnVA[17])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_18_;ColumnVA[18])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_19_;ColumnVA[19])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_20_;ColumnVA[20])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_21_;ColumnVA[21])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_22_;ColumnVA[22])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_23_;ColumnVA[23])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_24_;ColumnVA[24])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_25_;ColumnVA[25])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_26_;ColumnVA[26])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_27_;ColumnVA[27])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_28_;ColumnVA[28])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_29_;ColumnVA[29])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_30_;ColumnVA[30])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_31_;ColumnVA[31])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_32_;ColumnVA[32])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_33_;ColumnVA[33])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_34_;ColumnVA[34])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_35_;ColumnVA[35])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_36_;ColumnVA[36])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_37_;ColumnVA[37])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_38_;ColumnVA[38])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_39_;ColumnVA[39])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_40_;ColumnVA[40])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_41_;ColumnVA[41])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_42_;ColumnVA[42])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_43_;ColumnVA[43])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_44_;ColumnVA[44])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_45_;ColumnVA[45])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_46_;ColumnVA[46])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_47_;ColumnVA[47])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_48_;ColumnVA[48])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_49_;ColumnVA[49])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_50_;ColumnVA[50])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_51_;ColumnVA[51])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_52_;ColumnVA[52])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_53_;ColumnVA[53])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_54_;ColumnVA[54])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_55_;ColumnVA[55])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_56_;ColumnVA[56])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_57_;ColumnVA[57])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_58_;ColumnVA[58])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_59_;ColumnVA[59])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_60_;ColumnVA[60])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_61_;ColumnVA[61])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_62_;ColumnVA[62])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_63_;ColumnVA[63])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_64_;ColumnVA[64])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_65_;ColumnVA[65])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVA_66_;ColumnVA[66])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_1_;ColumnVM[1])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_2_;ColumnVM[2])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_3_;ColumnVM[3])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_4_;ColumnVM[4])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_5_;ColumnVM[5])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_6_;ColumnVM[6])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_7_;ColumnVM[7])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_8_;ColumnVM[8])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_9_;ColumnVM[9])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_10_;ColumnVM[10])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_11_;ColumnVM[11])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_12_;ColumnVM[12])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_13_;ColumnVM[13])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_14_;ColumnVM[14])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_15_;ColumnVM[15])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_16_;ColumnVM[16])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_17_;ColumnVM[17])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_18_;ColumnVM[18])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_19_;ColumnVM[19])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_20_;ColumnVM[20])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_21_;ColumnVM[21])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_22_;ColumnVM[22])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_23_;ColumnVM[23])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_24_;ColumnVM[24])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_25_;ColumnVM[25])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_26_;ColumnVM[26])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_27_;ColumnVM[27])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_28_;ColumnVM[28])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_29_;ColumnVM[29])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_30_;ColumnVM[30])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_31_;ColumnVM[31])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_32_;ColumnVM[32])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_33_;ColumnVM[33])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_34_;ColumnVM[34])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_35_;ColumnVM[35])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_36_;ColumnVM[36])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_37_;ColumnVM[37])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_38_;ColumnVM[38])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_39_;ColumnVM[39])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_40_;ColumnVM[40])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_41_;ColumnVM[41])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_42_;ColumnVM[42])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_43_;ColumnVM[43])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_44_;ColumnVM[44])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_45_;ColumnVM[45])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_46_;ColumnVM[46])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_47_;ColumnVM[47])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_48_;ColumnVM[48])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_49_;ColumnVM[49])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_50_;ColumnVM[50])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_51_;ColumnVM[51])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_52_;ColumnVM[52])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_53_;ColumnVM[53])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_54_;ColumnVM[54])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_55_;ColumnVM[55])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_56_;ColumnVM[56])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_57_;ColumnVM[57])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_58_;ColumnVM[58])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_59_;ColumnVM[59])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_60_;ColumnVM[60])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_61_;ColumnVM[61])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_62_;ColumnVM[62])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_63_;ColumnVM[63])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_64_;ColumnVM[64])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_65_;ColumnVM[65])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVM_66_;ColumnVM[66])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_1_;ColumnVX[1])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_2_;ColumnVX[2])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_3_;ColumnVX[3])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_4_;ColumnVX[4])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_5_;ColumnVX[5])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_6_;ColumnVX[6])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_7_;ColumnVX[7])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_8_;ColumnVX[8])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_9_;ColumnVX[9])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_10_;ColumnVX[10])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_11_;ColumnVX[11])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_12_;ColumnVX[12])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_13_;ColumnVX[13])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_14_;ColumnVX[14])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_15_;ColumnVX[15])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_16_;ColumnVX[16])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_17_;ColumnVX[17])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_18_;ColumnVX[18])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_19_;ColumnVX[19])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_20_;ColumnVX[20])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_21_;ColumnVX[21])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_22_;ColumnVX[22])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_23_;ColumnVX[23])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_24_;ColumnVX[24])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_25_;ColumnVX[25])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_26_;ColumnVX[26])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_27_;ColumnVX[27])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_28_;ColumnVX[28])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_29_;ColumnVX[29])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_30_;ColumnVX[30])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_31_;ColumnVX[31])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_32_;ColumnVX[32])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_33_;ColumnVX[33])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_34_;ColumnVX[34])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_35_;ColumnVX[35])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_36_;ColumnVX[36])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_37_;ColumnVX[37])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_38_;ColumnVX[38])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_39_;ColumnVX[39])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_40_;ColumnVX[40])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_41_;ColumnVX[41])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_42_;ColumnVX[42])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_43_;ColumnVX[43])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_44_;ColumnVX[44])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_45_;ColumnVX[45])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_46_;ColumnVX[46])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_47_;ColumnVX[47])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_48_;ColumnVX[48])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_49_;ColumnVX[49])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_50_;ColumnVX[50])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_51_;ColumnVX[51])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_52_;ColumnVX[52])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_53_;ColumnVX[53])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_54_;ColumnVX[54])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_55_;ColumnVX[55])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_56_;ColumnVX[56])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_57_;ColumnVX[57])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_58_;ColumnVX[58])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_59_;ColumnVX[59])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_60_;ColumnVX[60])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_61_;ColumnVX[61])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_62_;ColumnVX[62])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_63_;ColumnVX[63])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_64_;ColumnVX[64])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_65_;ColumnVX[65])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnVX_66_;ColumnVX[66])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnUN_24_;ColumnUN[24])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnUN_23_;ColumnUN[23])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnUN_21_;ColumnUN[21])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnUN_22_;ColumnUN[22])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnUN_19_;ColumnUN[19])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnUN_20_;ColumnUN[20])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnUN_18_;ColumnUN[18])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnUN_17_;ColumnUN[17])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnUN_12_;ColumnUN[12])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnUN_11_;ColumnUN[11])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnUN_10_;ColumnUN[10])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnUN_9_;ColumnUN[9])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnUN_16_;ColumnUN[16])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnUN_15_;ColumnUN[15])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnUN_14_;ColumnUN[14])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnUN_13_;ColumnUN[13])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnUN_1_;ColumnUN[1])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnUN_2_;ColumnUN[2])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnUN_4_;ColumnUN[4])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnUN_3_;ColumnUN[3])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnUN_6_;ColumnUN[6])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnUN_5_;ColumnUN[5])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnUN_7_;ColumnUN[7])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnUN_8_;ColumnUN[8])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_1_;ColumnSD[1])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_2_;ColumnSD[2])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_3_;ColumnSD[3])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_4_;ColumnSD[4])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_5_;ColumnSD[5])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_6_;ColumnSD[6])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_7_;ColumnSD[7])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_8_;ColumnSD[8])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_9_;ColumnSD[9])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_10_;ColumnSD[10])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_11_;ColumnSD[11])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_12_;ColumnSD[12])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_13_;ColumnSD[13])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_14_;ColumnSD[14])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_15_;ColumnSD[15])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_16_;ColumnSD[16])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_17_;ColumnSD[17])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_18_;ColumnSD[18])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_19_;ColumnSD[19])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_20_;ColumnSD[20])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_21_;ColumnSD[21])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_22_;ColumnSD[22])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_23_;ColumnSD[23])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_24_;ColumnSD[24])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_25_;ColumnSD[25])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_26_;ColumnSD[26])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_27_;ColumnSD[27])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_28_;ColumnSD[28])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_29_;ColumnSD[29])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_30_;ColumnSD[30])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_31_;ColumnSD[31])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_32_;ColumnSD[32])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_33_;ColumnSD[33])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_34_;ColumnSD[34])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_35_;ColumnSD[35])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_36_;ColumnSD[36])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_37_;ColumnSD[37])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_38_;ColumnSD[38])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_39_;ColumnSD[39])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_40_;ColumnSD[40])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_41_;ColumnSD[41])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_42_;ColumnSD[42])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_43_;ColumnSD[43])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_44_;ColumnSD[44])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_45_;ColumnSD[45])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_46_;ColumnSD[46])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_47_;ColumnSD[47])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_48_;ColumnSD[48])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_49_;ColumnSD[49])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_50_;ColumnSD[50])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_51_;ColumnSD[51])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_52_;ColumnSD[52])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_53_;ColumnSD[53])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_54_;ColumnSD[54])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_55_;ColumnSD[55])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_56_;ColumnSD[56])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_57_;ColumnSD[57])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_58_;ColumnSD[58])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_59_;ColumnSD[59])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_60_;ColumnSD[60])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_61_;ColumnSD[61])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_62_;ColumnSD[62])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_63_;ColumnSD[63])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_64_;ColumnSD[64])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_65_;ColumnSD[65])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnSD_66_;ColumnSD[66])
            {
                DecimalPlaces = 0:0;
            }
            column(GenSetup__Cons__Marksheet_Key1_;GenSetup."Cons. Marksheet Key1")
            {
                DecimalPlaces = 0:0;
            }
            column(GenSetup__Cons__Marksheet_Key2_;GenSetup."Cons. Marksheet Key2")
            {
                DecimalPlaces = 0:0;
            }
            column(SMM_2_;SMM[2])
            {
            }
            column(SMM_4_;SMM[4])
            {
            }
            column(SMM_3_;SMM[3])
            {
            }
            column(SMM_6_;SMM[6])
            {
            }
            column(SMM_5_;SMM[5])
            {
            }
            column(SMM_8_;SMM[8])
            {
            }
            column(SMM_7_;SMM[7])
            {
            }
            column(SMM_10_;SMM[10])
            {
            }
            column(SMM_9_;SMM[9])
            {
            }
            column(Chairman___FDesc;'Chairman '+FDesc)
            {
            }
            column(School_Caption;School_CaptionLbl)
            {
            }
            column(Department_Caption;Department_CaptionLbl)
            {
            }
            column(Programme_of_Study_Caption;Programme_of_Study_CaptionLbl)
            {
            }
            column(Stage_Caption;Stage_CaptionLbl)
            {
            }
            column(Academic_Year_Caption;Academic_Year_CaptionLbl)
            {
            }
            column(Consolidated_MarksheetCaption;Consolidated_MarksheetCaptionLbl)
            {
            }
            column(Semester_Caption;Semester_CaptionLbl)
            {
            }
            column(Programme_Option_Caption;Programme_Option_CaptionLbl)
            {
            }
            column(Registration_No_Caption;Registration_No_CaptionLbl)
            {
            }
            column(NamesCaption;NamesCaptionLbl)
            {
            }
            column(UNITS__Caption;UNITS__CaptionLbl)
            {
            }
            column(EmptyStringCaption;EmptyStringCaptionLbl)
            {
            }
            column(Guide_on_remarks_Caption;Guide_on_remarks_CaptionLbl)
            {
            }
            column(Total_Reg_Caption;Total_Reg_CaptionLbl)
            {
            }
            column(Mean_ScoreCaption;Mean_ScoreCaptionLbl)
            {
            }
            column(Maximum_ScoreCaption;Maximum_ScoreCaptionLbl)
            {
            }
            column(Minimum_ScoreCaption;Minimum_ScoreCaptionLbl)
            {
            }
            column(Units_Key_Caption;Units_Key_CaptionLbl)
            {
            }
            column(Approved_by_the_Departmental_Board_of_ExaminersCaption;Approved_by_the_Departmental_Board_of_ExaminersCaptionLbl)
            {
            }
            column(Approved_by_the_Faculty_Board_of_ExaminersCaption;Approved_by_the_Faculty_Board_of_ExaminersCaptionLbl)
            {
            }
            column(Signed_______________________________________Caption;Signed_______________________________________CaptionLbl)
            {
            }
            column(Signed_______________________________________Caption_Control1000000012;Signed_______________________________________Caption_Control1000000012Lbl)
            {
            }
            column(Signed_______________________________________Caption_Control1000000013;Signed_______________________________________Caption_Control1000000013Lbl)
            {
            }
            column(Approved_by_Cu_SenateCaption;Approved_by_Cu_SenateCaptionLbl)
            {
            }
            column(Chairperson_of_DepartmentCaption;Chairperson_of_DepartmentCaptionLbl)
            {
            }
            column(Chairperson_SenateCaption;Chairperson_SenateCaptionLbl)
            {
            }
            column(Standard_DeviationCaption;Standard_DeviationCaptionLbl)
            {
            }
            column(Course_Registration_Reg__Transacton_ID;"Reg. Transacton ID")
            {
            }
            column(Course_Registration_Programme;Programme)
            {
            }
            column(Course_Registration_Semester;Semester)
            {
            }
            column(Course_Registration_Register_for;"Register for")
            {
            }
            column(Course_Registration_Stage;Stage)
            {
            }
            column(Course_Registration_Unit;Unit)
            {
            }
            column(Course_Registration_Student_Type;"Student Type")
            {
            }
            column(Course_Registration_Entry_No_;"Entry No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                SCount:=SCount+1;
                i:=0;
                TScore:=0;
                RUnits:=0;
                MissingM:=false;
                MCourse := false;
                TReg:="ACA-Course Registration".Count;
                
                i:=0;
                repeat
                i := i + 1;
                ColumnV[i]:='';
                AvScoreCount[i]:=0;
                //AvScore[i]:=0;
                until i = 80;
                i:=0;
                
                
                
                if Dept = '' then begin
                if Prog.Get("ACA-Course Registration".Programme) then begin
                PName:=Prog.Description;
                FDesc:=Prog."School Code";
                
                i:=1;
                Gradings.Reset;
                Gradings.SetRange(Gradings.Category,Prog."Exam Category");
                if Gradings.Find('-') then begin
                repeat
                GLabel[i]:=Gradings.Range;
                GLabel2[i]:=Gradings.Grade;
                i:=i+1;
                until Gradings.Next=0;
                end;
                
                FacultyR.Reset;
                FacultyR.SetRange(FacultyR.Code,Prog."School Code");
                if FacultyR.Find('-') then
                FDesc:=FacultyR.Name;
                
                i:=0;
                DValue.Reset;
                DValue.SetRange(DValue.Code,ProgrammeRec."Department Code");
                DValue.SetRange(DValue."Dimension Code",'DEPARTMENT');
                if DValue.Find('-') then
                Dept:=DValue.Name;
                
                end;
                
                //IF Stages.GET("Course Registration".Programme,"Course Registration".Stage) THEN
                SDesc:="ACA-Course Registration".GetFilter("ACA-Course Registration"."Semester Filter");
                
                //IF ProgOptions.GET("Course Registration".Programme,"Course Registration".Stage,GETFILTER("Options Filter")) THEN
                //Comb:=ProgOptions.Desription;
                
                
                end;
                
                
                "ACA-Course Registration".CalcFields("ACA-Course Registration"."Units Taken","ACA-Course Registration"."Units Passed",
                                                 "ACA-Course Registration"."Units Failed" );
                
                
                UnitsR.Reset;
                UnitsR.SetCurrentkey(UnitsR."Programme Code",UnitsR."Stage Code",UnitsR.Code,UnitsR."Programme Option");
                UnitsR.SetRange(UnitsR.Show,true);
                UnitsR.SetFilter(UnitsR."Student No. Filter","ACA-Course Registration"."Student No.");
                UnitsR.SetFilter(UnitsR."Stage Filter",GetFilter("Stage Filter"));
                UnitsR.SetFilter(UnitsR."Semester Filter",GetFilter("Semester Filter"));
                UnitsR.SetFilter(UnitsR."Reg. ID Filter","ACA-Course Registration"."Reg. Transacton ID");
                if UnitsR.Find('-') then begin
                repeat
                UnitsR.CalcFields(UnitsR."Total Score",UnitsR."Unit Registered",UnitsR."Re-Sit",UnitsR.Audit);
                USkip := false;
                
                //Check if option
                
                /*
                IF UnitsR."Programme Option" <> '' THEN BEGIN
                IF UnitsR."Programme Option" <> "Course Registration".Options THEN
                USkip := TRUE;
                END;
                */
                //Check if option
                
                GradeCategory:='';
                ProgrammeRec.Reset;
                if ProgrammeRec.Get("ACA-Course Registration".Programme) then
                GradeCategory:=ProgrammeRec."Exam Category";
                if GradeCategory='' then Error('Please note that you must specify Exam Category in Programme Setup');
                
                
                if USkip = false then begin
                Grade:='';
                //Grades
                if UnitsR."Total Score" > 0 then begin
                Gradings.Reset;
                Gradings.SetRange(Gradings.Category,GradeCategory);
                LastGrade:='';
                LastRemark:='';
                LastScore:=0;
                if Gradings.Find('-') then begin
                ExitDo:=false;
                repeat
                if UnitsR."Total Score" < LastScore then begin
                if ExitDo = false then begin
                Grade:=LastGrade;
                Remarks:='PASS';
                ExitDo:=true;
                end;
                end;
                LastGrade:=Gradings.Grade;
                LastScore:=Gradings."Up to";
                if Gradings.Failed = true then
                LastRemark:='FAIL'
                else
                LastRemark:='PASS';
                
                until Gradings.Next = 0;
                
                if ExitDo = false then begin
                Gradings2.Reset;
                Gradings2.SetRange(Gradings2.Category,GradeCategory);
                if Gradings2.Find('+') then begin
                Grade:=Gradings2.Grade;
                Remarks:=Gradings2.Remarks;
                end;
                
                end;
                end;
                
                end else begin
                Grade:='';
                Remarks:='Not Done';
                end;
                /*
                RepeatRemarks:='';
                StudUnits.RESET;
                StudUnits.SETRANGE(StudUnits."Student No.","Course Registration"."Student No.");
                StudUnits.SETRANGE(StudUnits.Unit,UnitsR.Code);
                IF StudUnits.FIND('-') THEN BEGIN
                StudUnits.CALCFIELDS(StudUnits."Total Score");
                LastRemark:='';
                IF FORMAT(StudUnits."Marks Status")<>'' THEN
                RepeatRemarks:=FORMAT(StudUnits."Marks Status");
                
                StudUnits.Grade:=GetGrade(StudUnits."Total Score",StudUnits.Unit);
                StudUnits."Final Score":=StudUnits."Total Score";
                StudUnits."Result Status":=LastRemark;
                IF StudUnits."Total Score"=0 THEN
                StudUnits."Result Status":='FAIL';
                //StudUnits.MODIFY;
                END;
                */
                //Grades
                //Course Category
                if UnitsR."Unit Type" = UnitsR."unit type"::Elective then
                CCat:='-'
                else
                CCat:='';
                
                if UnitsR."Re-Sit" > 0 then
                CCat:='+';
                
                if UnitsR.Audit > 0 then
                CCat:='#';
                
                
                //Check if unit done
                if UnitsR."Unit Registered" < 1 then
                CCat:='--';
                
                
                //Course Category
                /*
                IF LastRemark<>'PASS' THEN
                CCat:='*'
                ELSE
                CCat:='';
                */
                
                // CAT and EXAM Checking
                if CheckCAT=true then begin
                StudUnits.Reset;
                StudUnits.SetRange(StudUnits."Student No.","ACA-Course Registration"."Student No.");
                StudUnits.SetRange(StudUnits.Unit,UnitsR.Code);
                StudUnits.SetRange(StudUnits."Supp Taken",false);
                if StudUnits.Find('-') then begin
                StudUnits.CalcFields(StudUnits."Exam Marks");
                StudUnits.CalcFields(StudUnits."CAT Total Marks");
                StudUnits.CalcFields(StudUnits."Total Score");
                if (StudUnits."Total Score")<>0 then begin
                if StudUnits."Exam Marks"=0 then
                CCat:='c';
                if StudUnits."CAT Total Marks"=0 then
                CCat:='e';
                end;
                end;
                end;
                
                //IF GetGradeStatus(UnitsR."Total Score","Course Registration".Programme,UnitsR.Code) =TRUE THEN
                //CCat:='*';
                
                i:=i+1;
                ColumnH[i]:=UnitsR.Code;
                //UnitsR.CALCFIELDS(UnitsR."Total Score");
                //AvScore[i]:=AvScore[i]+UnitsR."Total Score";
                // Get Total Score For all the students and this unit
                
                UnitsRRR.Reset;
                UnitsRRR.SetRange(UnitsRRR.Code,UnitsR.Code);
                UnitsRRR.SetRange(UnitsRRR.Show,true);
                UnitsRRR.SetFilter(UnitsRRR."Stage Filter",GetFilter("Stage Filter"));
                UnitsRRR.SetFilter(UnitsRRR."Semester Filter",GetFilter("Semester Filter"));
                if UnitsRRR.Find('-') then begin
                repeat
                UnitsRRR.CalcFields("Total Score");
                AvScore[i]:=AvScore[i]+UnitsRRR."Total Score";
                until UnitsRRR.Next=0;
                end;
                
                
                
                //uColumnV[i]:=FORMAT(UnitsR."No. Units");
                sColumnV[i]:=CopyStr(UnitsR."Stage Code",3,2);
                if UnitsR."Total Score" = 0 then
                if CCat = '--' then
                ColumnV[i]:=''
                else begin
                MissingM:=true;
                MCourse := true;
                ColumnV[i]:='X';
                //RUnits:=RUnits+UnitsR."No. Units";
                
                
                
                end
                else begin
                
                if GetGradeStatus(UnitsR."Total Score","ACA-Course Registration".Programme,UnitsR.Code) =true then
                CCat:='*';
                UnitsR.CalcFields(UnitsR."Exams Done");
                UnitsR.CalcFields(UnitsR."Failed Total Score");
                if (UnitsR."Exams Done">1) and (UnitsR."Failed Total Score">0) then
                ColumnV[i]:=Format(ROUND(UnitsR."Failed Total Score",1,'='))+'|'+Format(ROUND(UnitsR."Total Score",1,'='))
                else
                ColumnV[i]:=Format(ROUND(UnitsR."Total Score",1,'=')) +CCat;
                
                //ColumnV[i]:=FORMAT(UnitsR."Total Score") + CCat;
                TScore:=TScore+UnitsR."Total Score";
                
                //RUnits:=RUnits+UnitsR."No. Units";
                end;
                
                
                
                if DMarks = true then
                i:=0;
                
                end;
                
                until UnitsR.Next = 0;
                end;
                
                RepeatRemarks:='';
                StudUnits.Reset;
                StudUnits.SetRange(StudUnits."Student No.","ACA-Course Registration"."Student No.");
                StudUnits.SetRange(StudUnits.Programme,"ACA-Course Registration".Programme);
                StudUnits.SetFilter(StudUnits.Stage,GetFilter("Stage Filter"));
                StudUnits.SetFilter(StudUnits.Semester,GetFilter("Semester Filter"));
                StudUnits.SetFilter(StudUnits."Stage Filter",GetFilter("Stage Filter"));
                StudUnits.SetFilter(StudUnits."Semester Filter",GetFilter("Semester Filter"));
                if StudUnits.Find('-') then begin
                
                repeat
                StudUnits.CalcFields(StudUnits."Total Score");
                /*
                LastRemark:='';
                IF FORMAT(StudUnits."Marks Status")<>'' THEN
                RepeatRemarks:=FORMAT(StudUnits."Marks Status");
                
                StudUnits.Grade:=GetGrade(StudUnits."Total Score",StudUnits.Unit);
                StudUnits."Final Score":=StudUnits."Total Score";
                StudUnits."Result Status":=LastRemark;
                IF GetGradeStatus(StudUnits."Total Score",StudUnits.Programme,StudUnits.Unit)=TRUE THEN
                StudUnits."Result Status":='FAIL'
                ELSE
                StudUnits."Result Status":='PASS';
                
                IF StudUnits."Total Score"=0 THEN
                StudUnits."Result Status":='FAIL';
                */
                if GetGradeStatus(UnitsR."Total Score","ACA-Course Registration".Programme,UnitsR.Code) =true then
                StudUnits."Result Status":='FAIL'
                else
                StudUnits."Result Status":='PASS';
                
                //StudUnits.MODIFY;
                until StudUnits.Next=0;
                end;
                
                
                StudUnits.Reset;
                StudUnits.SetRange(StudUnits."Student No.","ACA-Course Registration"."Student No.");
                StudUnits.SetRange(StudUnits.Programme,"ACA-Course Registration".Programme);
                //StudUnits.SETFILTER(StudUnits.Stage,GETFILTER("Stage Filter"));
                //StudUnits.SETFILTER(StudUnits.Semester,GETFILTER("Semester Filter"));
                if StudUnits.Find('-') then begin
                 repeat
                if GetGradeStatus(StudUnits."Final Score","ACA-Course Registration".Programme,StudUnits.Unit) =true then
                StudUnits."Result Status":='FAIL'
                else
                StudUnits."Result Status":='PASS';
                StudUnits.Grade:=GetGrade(StudUnits."Final Score",StudUnits.Unit);
                //StudUnits.MODIFY;
                 until StudUnits.Next=0;
                 end;
                
                
                if Cust.Get("ACA-Course Registration"."Student No.") then
                
                //Generate Summary
                UTaken:=0;
                UPassed:=0;
                UFailed:=0;
                CAve:=0;
                
                if DSummary = false then begin
                
                //Jump one column
                
                i:=i+1;
                ColumnH[i]:='';
                ColumnV[i]:='';
                
                
                CReg.Reset;
                CReg.SetRange(CReg."Student No.","ACA-Course Registration"."Student No.");
                CReg.SetRange(CReg.Reversed,false);
                CReg.SetFilter(CReg.Stage,GetFilter("ACA-Course Registration"."Stage Filter"));
                CReg.SetFilter(CReg.Semester,GetFilter("ACA-Course Registration"."Semester Filter"));
                CReg.SetFilter(CReg.Programme,GetFilter("ACA-Course Registration"."Programme Filter"));
                CReg.SetFilter(CReg."Stage Filter",GetFilter("ACA-Course Registration"."Stage Filter"));
                CReg.SetFilter(CReg."Semester Filter",GetFilter("ACA-Course Registration"."Semester Filter"));
                
                if CReg.Find('-') then begin
                repeat
                CReg.CalcFields(CReg."Units Taken",CReg."Units Passed",
                                                 CReg."Units Failed",CReg."Units Repeat");
                
                UTaken:=UTaken+CReg."Units Taken";
                UPassed:=UPassed+CReg."Units Passed";
                UFailed:=UFailed+CReg."Units Failed"+CReg."Units Repeat";
                
                until CReg.Next = 0;
                end;
                
                "ACA-Course Registration".CalcFields("ACA-Course Registration"."Cum Average");
                "ACA-Course Registration".CalcFields("ACA-Course Registration"."Cum Units Done");
                "ACA-Course Registration".CalcFields("ACA-Course Registration"."Cum Units Failed");
                "ACA-Course Registration".CalcFields("ACA-Course Registration"."Cum Units Passed");
                "ACA-Course Registration".CalcFields("ACA-Course Registration"."CF Count");
                "ACA-Course Registration".CalcFields("ACA-Course Registration"."CF Total Score");
                
                i:=i+1;
                ColumnH[i]:='Reg Units';
                //ColumnV[i]:=FORMAT(UTaken);
                ColumnV[i]:=Format("ACA-Course Registration"."Cum Units Done");
                
                //TReg:=TReg+1;
                AvScoreCount[i]:=AvScoreCount[i]+"ACA-Course Registration"."Cum Units Done";
                
                //ColumnV[i]:=FORMAT(ROUND(YearScore/CourseCount,1,'='));
                //CAve:=ROUND(YearScore/CourseCount,1,'=');
                
                
                
                i:=i+1;
                ColumnH[i]:='Unt Passed';
                //IF UTaken > 0 THEN
                ColumnV[i]:=Format("ACA-Course Registration"."Cum Units Passed");
                AvScore[i]:=AvScore[i]+"ACA-Course Registration"."Cum Units Passed";
                
                
                i:=i+1;
                ColumnH[i]:='Papers Failed';
                ColumnV[i]:=Format("ACA-Course Registration"."Cum Units Done"-"ACA-Course Registration"."Cum Units Passed");
                AvScore[i]:=AvScore[i]+"ACA-Course Registration"."Cum Units Failed";
                
                i:=i+1;
                ColumnH[i]:='CF% Failed';
                if ("ACA-Course Registration"."Cum Units Passed"<>0) and ("ACA-Course Registration"."Cum Units Done"<>0) then
                ColumnV[i]:=Format(ROUND((("ACA-Course Registration"."Cum Units Done"-"ACA-Course Registration"."Cum Units Passed")/
                "ACA-Course Registration"."Cum Units Done")*100,1));
                
                
                
                i:=i+1;
                //calculate yearly average
                ColumnH[i]:='Cum Average';
                
                if("ACA-Course Registration"."CF Total Score"<>0) and ("ACA-Course Registration"."CF Count"<>0) then begin
                ColumnV[i]:=Format(ROUND("ACA-Course Registration"."CF Total Score"/"ACA-Course Registration"."CF Count",1,'='));
                AvScore[i]:=AvScore[i]+ROUND("ACA-Course Registration"."CF Total Score"/"ACA-Course Registration"."CF Count",1,'=');
                //"Course Registration"."Cumm Score":=ROUND("Course Registration"."Cum Average"/"Course Registration"."Cum Units Done",1,'=');
                end;
                //"Course Registration".MODIFY;
                // Current Average
                i:=i+1;
                MaxYear := GetRangemax("ACA-Course Registration"."Stage Filter");
                MaxSem := GetRangemax("ACA-Course Registration"."Semester Filter");
                
                ColumnH[i]:='Cur Average';
                    CReg.Reset;
                    CReg.SetRange(CReg."Student No.","ACA-Course Registration"."Student No.");
                    CReg.SetFilter(CReg.Programme,"ACA-Course Registration".Programme);
                    CReg.SetRange("Stage Filter",'Y1S1',MaxYear);
                    CReg.SetRange("Semester Filter",'',MaxSem);
                    if CReg.Find('-') then begin
                    CReg.CalcFields(CReg."CF Total Score");
                    CReg.CalcFields(CReg."CF Count");
                    if(CReg."CF Total Score"<>0) and (CReg."CF Count"<>0) then
                
                     ColumnV[i]:=Format(ROUND(CReg."CF Total Score"/CReg."CF Count",1,'='));
                    end;
                
                
                i:=i+1;
                
                //calculate yearly average GRADE
                DefUnit:='DEF';
                ColumnH[i]:='Grade';
                if("ACA-Course Registration"."CF Total Score"<>0) and ("ACA-Course Registration"."CF Count"<>0) then
                ColumnV[i]:=GetGrade(ROUND("ACA-Course Registration"."CF Total Score"/"ACA-Course Registration"."CF Count",0.5,'='),DefUnit);
                
                i:=i+1;
                
                ColumnH[i]:='Rmk';
                ColumnV[i]:="ACA-Course Registration"."Exam Status";
                
                if ResultStatus.Get("ACA-Course Registration"."Exam Status") then
                ColumnV[i]:=ResultStatus.Prefix;
                
                "ACA-Course Registration".CalcFields("Cum Units Done");
                "ACA-Course Registration".CalcFields("Cum Units Passed");
                "ACA-Course Registration".CalcFields("Cum Units Failed");
                
                if ("ACA-Course Registration"."Cum Units Done" <> 0) and ("ACA-Course Registration"."Cum Units Passed"<>0)
                and ("ACA-Course Registration"."Cum Units Failed"=0) then
                
                if "ACA-Course Registration"."Cum Units Done"="ACA-Course Registration"."Cum Units Passed" then begin
                
                TPass:=TPass+1;
                if ResultStatus.Get('PASS')  then begin
                if (ResultStatus."Manual Status Processing"=false) then begin
                ColumnV[i]:=ResultStatus.Prefix;
                "ACA-Course Registration"."Exam Status":='PASS';
                "ACA-Course Registration".Modify;
                end;
                end;
                end;
                
                if "ACA-Course Registration"."Cum Units Failed" > 0 then begin
                if ResultStatus.Get('FAIL')  then begin
                if (ResultStatus."Manual Status Processing"=false) then begin
                ColumnV[i]:=ResultStatus.Prefix;
                "ACA-Course Registration"."Exam Status":='FAIL';
                "ACA-Course Registration".Modify;
                end;
                if MCourse = false then
                TFail:=TFail+1;
                end;
                end;
                
                if MCourse = true then begin
                if ResultStatus.Get('INCOMPLETE') then
                if (ResultStatus."Manual Status Processing"=false) then begin
                ColumnV[i]:=ResultStatus.Prefix;
                
                "ACA-Course Registration"."Exam Status":='INCOMPLETE';
                "ACA-Course Registration".Modify;
                //END;
                TMiss:=TMiss+1;
                end;
                end;
                
                if "ACA-Course Registration"."Cum Units Failed" >7 then begin
                
                if ResultStatus.Get('DISCONTINUED') then
                if (ResultStatus."Manual Status Processing"=false) then begin
                ColumnV[i]:=ResultStatus.Prefix;
                "ACA-Course Registration"."Exam Status":='DISCONTINUED';
                "ACA-Course Registration".Modify;
                
                TDiscount:=TDiscount+1;
                end;
                end;
                
                if ("ACA-Course Registration"."Cum Units Failed" <8) and ("ACA-Course Registration"."Cum Units Failed" >5) then begin
                if ResultStatus.Get('REPEAT') then
                if (ResultStatus."Manual Status Processing"=false) then begin
                ColumnV[i]:=ResultStatus.Prefix;
                "ACA-Course Registration"."Exam Status":='REPEAT';
                "ACA-Course Registration".Modify;
                
                TRepeat:=TRepeat+1;
                end;
                end;
                end;
                /*
                IF Prog.GET("Course Registration".Programme) THEN BEGIN
                IF "Course Registration"."Units Taken" < Prog."Min No. of Courses" THEN
                ColumnV[i]:='?';
                END;
                */
                if Cust.Status=Cust.Status::"Dropped Out" then
                ColumnV[i]:='Z';
                
                /*
                IF (UTaken < 1) OR ((UPassed<14) AND (ColumnV[i]='P')) THEN   //BKK
                ColumnV[i]:='?';
                
                
                i:=i+1;
                ColumnH[i]:='Brd Rmk';
                ColumnV[i]:='';
                 */
                i:=0;
                UnitsR.Reset;
                UnitsR.SetRange(UnitsR.Show,true);
                if UnitsR.Find('-') then begin
                repeat
                i:=i+1;
                if i<25 then
                ColumnUN[i]:=UnitsR.Code+' - '+UnitsR.Desription;
                until UnitsR.Next=0;
                end;
                
                //END;
                
                
                //END;
                //Generate Summary
                /*
                  j:=2;
                   FOR i:=1 TO 80 DO BEGIN
                   IF j<80 THEN
                   j:=j+1;
                   IF (AvScore[i]<>0) AND (TReg<>0) THEN  BEGIN
                   ColumnVA[i]:=FORMAT(ROUND((AvScore[i]/TReg),0.01,'>'));
                   STD[i]:=STD[i]+ROUND((AvScore[i]-(AvScore[i]/TReg)),0.01,'>');
                   END;
                   IF ("Course Registration".COUNT<>0) AND (STD[i]<>0) THEN
                   STD[i]:=POWER((STD[i]/"Course Registration".COUNT),0.5);
                   IF STD[i]>0 THEN
                   ColumnSD[i]:=FORMAT(ROUND(STD[i],0.01,'>'));
                
                   StudUnits.RESET;
                   StudUnits.SETCURRENTKEY("Final Score");
                   StudUnits.SETRANGE(StudUnits.Unit,ColumnH[i]);
                   StudUnits.SETFILTER(StudUnits.Programme,"Course Registration".GETFILTER("Programme Filter"));
                   StudUnits.SETFILTER(StudUnits.Stage,"Course Registration".GETFILTER("Course Registration"."Stage Filter"));
                   StudUnits.SETFILTER(StudUnits.Semester,"Course Registration".GETFILTER("Course Registration"."Semester Filter"));
                   StudUnits.SETFILTER(StudUnits."Final Score",'<>%1',0);
                   IF StudUnits.FIND('+') THEN
                   ColumnVM[i]:=FORMAT(ROUND(StudUnits."Final Score",0.01,'>'));
                
                   StudUnits.RESET;
                   StudUnits.SETCURRENTKEY("Final Score");
                   StudUnits.SETRANGE(StudUnits.Unit,ColumnH[i]);
                   StudUnits.SETFILTER(StudUnits.Programme,"Course Registration".GETFILTER("Programme Filter"));
                   StudUnits.SETFILTER(StudUnits.Stage,"Course Registration".GETFILTER("Course Registration"."Stage Filter"));
                   StudUnits.SETFILTER(StudUnits.Semester,"Course Registration".GETFILTER("Course Registration"."Semester Filter"));
                   StudUnits.SETFILTER(StudUnits."Final Score",'<>%1',0);
                   IF StudUnits.FIND('-') THEN
                   ColumnVX[i]:=FORMAT(ROUND(StudUnits."Final Score",0.01,'>'));
                  //   ColumnVX[i]:='000';
                  // END;
                END;
                
                CReg.RESET;
                CReg.SETCURRENTKEY("Student No.","Cumm Score");
                CReg.ASCENDING:=TRUE;
                CReg.SETRANGE(CReg.Programme,"Course Registration".Programme);
                CReg.SETFILTER(CReg.Stage,"Course Registration".GETFILTER("Course Registration"."Stage Filter"));
                CReg.SETFILTER(CReg.Semester,"Course Registration".GETFILTER("Course Registration"."Semester Filter"));
                //IF CReg.FIND('-') THEN
                
                i:=1;
                ResultStatus.RESET;
                ResultStatus.SETCURRENTKEY(ResultStatus."Order No");
                ResultStatus.SETFILTER(ResultStatus."Programme Filter","Course Registration".GETFILTER("Course Registration"."Programme Filter"));
                ResultStatus.SETFILTER(ResultStatus."Stage Filter","Course Registration".GETFILTER("Course Registration"."Stage Filter"));
                ResultStatus.SETFILTER(ResultStatus.Semester,"Course Registration".GETFILTER("Course Registration".Semester));
                ResultStatus.SETFILTER(ResultStatus."Session Filter","Course Registration".GETFILTER("Course Registration".Session));
                IF ResultStatus.FIND('-') THEN BEGIN
                REPEAT
                IF ResultStatus."Order No"<>0 THEN BEGIN
                ResultStatus.CALCFIELDS(ResultStatus."Students Count Cumm");
                SMM[i]:=ResultStatus.Code+'='+FORMAT(ResultStatus."Students Count Cumm");
                i:=i+1;
                END;
                UNTIL ResultStatus.NEXT=0;
                END;
                   */

            end;

            trigger OnPreDataItem()
            begin
                FDesc:='';
                //Dept:='';
                SDesc:='';
                Comb:='';

                SCount:=0;
                GenSetup.Get;


                if Sem.Get(GetFilter("ACA-Course Registration".Semester)) then
                SemYear:=Sem."Academic Year";

                //Intake:=CReg."Intake Code";
                "ACA-Course Registration".SetFilter(Programme,GetFilter("Programme Filter"));
                //"Course Registration".SETFILTER("Course Registration".Semester,GETFILTER("Course Registration"."Semester Filter"));
                "ACA-Course Registration".SetFilter("ACA-Course Registration".Options,GetFilter("Options Filter"));
                "ACA-Course Registration".SetFilter("ACA-Course Registration".Stage,"ACA-Course Registration".GetFilter("ACA-Course Registration"."Stage Filter"))
                ;

                if Prog.Get(GetFilter("Programme Filter")) then begin
                PName:=Prog.Description;
                FDesc:=Prog."School Code";


                FacultyR.Reset;
                FacultyR.SetRange(FacultyR.Code,Prog."School Code");
                if FacultyR.Find('-') then
                FDesc:=FacultyR.Name;

                DValue.Reset;
                DValue.SetRange(DValue.Code,Prog."Department Code");
                DValue.SetRange(DValue."Dimension Code",'DEPARTMENT');
                if DValue.Find('-') then
                Dept:=DValue.Name;

                end;



                UnitsR.Reset;
                UnitsR.ModifyAll(UnitsR.Show,false);
                StudUnits.Reset;
                StudUnits.ModifyAll(StudUnits.Show,false);

                CReg.Reset;
                CReg.SetFilter(CReg.Programme,GetFilter("Programme Filter"));
                CReg.SetFilter(CReg.Stage,GetFilter("Stage Filter"));
                CReg.SetFilter(CReg.Options,GetFilter("Options Filter"));
                CReg.SetFilter(CReg.Semester,GetFilter("Semester Filter"));
                if CReg.Find('-') then begin
                repeat

                StudUnits.Reset;
                //StudUnits.SETCURRENTKEY(StudUnits."Reg. Transacton ID",StudUnits."Student No.");
                StudUnits.SetRange(StudUnits.Programme,CReg.Programme);
                //StudUnits.SETRANGE(StudUnits."Reg. Transacton ID",CReg."Reg. Transacton ID");
                StudUnits.SetRange(StudUnits."Student No.",CReg."Student No.");
                StudUnits.SetFilter(StudUnits.Stage,GetFilter("Stage Filter"));
                StudUnits.SetFilter(StudUnits.Semester,CReg.Semester);
                //StudUnits.SETFILTER(StudUnits."Reg Option",GETFILTER("Options Filter"));
                StudUnits.SetFilter(StudUnits."Session Code",GetFilter(Session));
                //StudUnits.SETRANGE(StudUnits.Taken,TRUE);
                StudUnits.SetRange(Blocked,0);
                StudUnits.SetFilter("Total Score",'>%1',0);
                if ShowResit=true then
                StudUnits.SetRange(StudUnits."Re-Take",false);
                if StudUnits.Find('-') then begin

                repeat
                StudUnits.CalcFields("Reg Option");
                //IF StudUnits."Total Score">0 THEN
                StudUnits.Show:=true;
                StudUnits.Modify;
                UnitsR.Reset;
                UnitsR.SetCurrentkey(UnitsR."Programme Code",UnitsR."Stage Code",UnitsR.Code);
                UnitsR.SetRange(UnitsR."Programme Code",StudUnits.Programme);
                UnitsR.SetRange(UnitsR."Stage Code",StudUnits.Stage);
                UnitsR.SetRange(UnitsR.Code,StudUnits.Unit);
                if UnitsR.Find('-') and (ShowCount<60) then begin
                if UnitsR.Show = false then begin
                //END ELSE BEGIN
                ShowCount:=ShowCount+1;
                UnitsR.Show:=true;
                //IF StudUnits."Reg Option"=CReg.Options THEN
                if UnitsR."Unit Type"=UnitsR."unit type"::Core then
                UnitsR.Modify;

                if StudUnits."Reg Option"=CReg.Options then
                UnitsR.Modify;

                //END;
                end;
                end;
                until StudUnits.Next = 0;
                end;
                if (CReg.Options<>'')  then begin
                OptionsComb.Reset;
                //OptionsComb.SETRANGE(OptionsComb.Unit,UnitsR.Code);
                OptionsComb.SetRange(OptionsComb.Programme,CReg.Programme);
                OptionsComb.SetRange(OptionsComb.Option,CReg.Options);
                OptionsComb.SetRange(OptionsComb.Stage,CReg.Stage);
                if OptionsComb.Find('-') then begin
                repeat
                UnitsR.Reset;
                UnitsR.SetRange(UnitsR.Code,OptionsComb.Unit);
                UnitsR.SetRange(UnitsR."Programme Code",CReg.Programme);
                UnitsR.SetRange(UnitsR."Stage Code",CReg.Stage);
                if UnitsR.Find('-') then begin
                //ShowCount:=ShowCount+1;
                UnitsR.Show:=true;
                //UnitsR.MODIFY;
                end;
                until OptionsComb.Next=0;
                end;
                end;
                until CReg.Next = 0;
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(DMarks;DMarks)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dont Show Marks';
                }
                field(CheckCAT;CheckCAT)
                {
                    ApplicationArea = Basic;
                    Caption = 'Check if CATs and EXAMs Exists';
                }
                field(ShowResit;ShowResit)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dont Show Re-Sit Units';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Cust: Record Customer;
        Charges: Record UnknownRecord61515;
        ColumnH: array [80] of Text[100];
        ColumnV: array [80] of Text[30];
        ColumnVM: array [80] of Text[30];
        ColumnVX: array [80] of Text[30];
        ColumnVA: array [80] of Text[30];
        ColumnSD: array [80] of Text[200];
        ColumnUN: array [80] of Text[200];
        i: Integer;
        j: Integer;
        TColumnV: array [80] of Decimal;
        SCount: Integer;
        UnitsR: Record UnknownRecord61517;
        UnitsRR: Record UnknownRecord61517;
        uColumnV: array [80] of Text[30];
        UnitsRRR: Record UnknownRecord61517;
        sColumnV: array [80] of Text[30];
        Prog: Record UnknownRecord61511;
        Stages: Record UnknownRecord61516;
        RFound: Boolean;
        UDesc: Text[200];
        Units: Record UnknownRecord61517;
        Result: Decimal;
        Grade: Text[150];
        Remarks: Text[150];
        Gradings: Record UnknownRecord61599;
        Gradings2: Record UnknownRecord61599;
        TotalScore: Decimal;
        LastGrade: Code[20];
        LastScore: Decimal;
        ExitDo: Boolean;
        Desc: Text[200];
        OScore: Decimal;
        OUnits: Integer;
        MeanScore: Decimal;
        MeanGrade: Code[20];
        LastRemark: Text[200];
        CCat: Text[30];
        TScore: Decimal;
        RUnits: Decimal;
        SkipCount: Integer;
        MissingM: Boolean;
        DValue: Record "Dimension Value";
        MaxSem: Code[50];
        MaxYear: Code[50];
        FDesc: Text[200];
        Dept: Text[200];
        PName: Text[200];
        SDesc: Text[200];
        Comb: Text[200];
        DMarks: Boolean;
        DSummary: Boolean;
        USkip: Boolean;
        CReg: Record UnknownRecord61532;
        UTaken: Integer;
        UPassed: Integer;
        UFailed: Integer;
        MCourse: Boolean;
        StudUnits: Record UnknownRecord61549;
        StudUnits2: Record UnknownRecord61549;
        UnitCount: Integer;
        YearScore: Decimal;
        CourseCount: Decimal;
        DontCont: Boolean;
        CAve: Decimal;
        Intake: Record UnknownRecord61532;
        ShowCount: Integer;
        GradeCategory: Code[20];
        ProgrammeRec: Record UnknownRecord61511;
        GLabel: array [6] of Code[20];
        GLabel2: array [6] of Code[100];
        FacultyR: Record "Dimension Value";
        TReg: Integer;
        TPass: Integer;
        TFail: Integer;
        TMiss: Integer;
        TSupp: Integer;
        CheckCAT: Boolean;
        AvScore: array [80] of Decimal;
        MinScore: array [80] of Decimal;
        AvScoreCount: array [80] of Decimal;
        RepeatRemarks: Text[30];
        STD: array [81] of Decimal;
        GenSetup: Record UnknownRecord61534;
        Sem: Record UnknownRecord61692;
        SemYear: Code[100];
        ShowResit: Boolean;
        TRepeat: Integer;
        TDiscount: Integer;
        ResultStatus: Record UnknownRecord61739;
        SMM: array [20] of Text[100];
        DefUnit: Code[20];
        OptionsComb: Record UnknownRecord61601;
        School_CaptionLbl: label 'School:';
        Department_CaptionLbl: label 'Department:';
        Programme_of_Study_CaptionLbl: label 'Programme of Study:';
        Stage_CaptionLbl: label 'Stage:';
        Academic_Year_CaptionLbl: label 'Academic Year:';
        Consolidated_MarksheetCaptionLbl: label 'Consolidated Marksheet';
        Semester_CaptionLbl: label 'Semester:';
        Programme_Option_CaptionLbl: label 'Programme Option:';
        Registration_No_CaptionLbl: label 'Registration No.';
        NamesCaptionLbl: label 'Names';
        UNITS__CaptionLbl: label 'UNITS=>';
        EmptyStringCaptionLbl: label '#';
        Guide_on_remarks_CaptionLbl: label 'Guide on remarks:';
        Total_Reg_CaptionLbl: label 'Total Reg.';
        Mean_ScoreCaptionLbl: label 'Mean Score';
        Maximum_ScoreCaptionLbl: label 'Maximum Score';
        Minimum_ScoreCaptionLbl: label 'Minimum Score';
        Units_Key_CaptionLbl: label 'Units Key:';
        Approved_by_the_Departmental_Board_of_ExaminersCaptionLbl: label 'Approved by the Departmental Board of Examiners';
        Approved_by_the_Faculty_Board_of_ExaminersCaptionLbl: label 'Approved by the Faculty Board of Examiners';
        Signed_______________________________________CaptionLbl: label 'Signed:______________________________________';
        Signed_______________________________________Caption_Control1000000012Lbl: label 'Signed:______________________________________';
        Signed_______________________________________Caption_Control1000000013Lbl: label 'Signed:______________________________________';
        Approved_by_Cu_SenateCaptionLbl: label 'Approved by Cu Senate';
        Chairperson_of_DepartmentCaptionLbl: label 'Chairperson of Department';
        Chairperson_SenateCaptionLbl: label 'Chairperson Senate';
        Standard_DeviationCaptionLbl: label 'Standard Deviation';


    procedure GetGrade(Marks: Decimal;UnitG: Code[20]) xGrade: Text[100]
    begin
        GradeCategory:='';
        UnitsRR.Reset;
        UnitsRR.SetRange(UnitsRR."Programme Code","ACA-Course Registration".Programme);
        UnitsRR.SetRange(UnitsRR.Code,UnitG);
        UnitsRR.SetRange(UnitsRR."Stage Code","ACA-Course Registration".Stage);
        if( UnitsRR.Find('-')) and (UnitsRR."Default Exam Category"<>'') then begin
        GradeCategory:=UnitsRR."Default Exam Category";
        end else begin
        ProgrammeRec.Reset;
        if ProgrammeRec.Get("ACA-Course Registration".Programme) then
        GradeCategory:=ProgrammeRec."Exam Category";
        if GradeCategory='' then Error('Please note that you must specify Exam Category in Programme Setup');
        end;

        xGrade:='';
        if Marks > 0 then begin
        Gradings.Reset;
        Gradings.SetRange(Gradings.Category,GradeCategory);
        LastGrade:='';
        LastRemark:='';
        LastScore:=0;
        if Gradings.Find('-') then begin
        ExitDo:=false;
        repeat
        LastScore:=Gradings."Up to";
        if Marks < LastScore then begin
        if ExitDo = false then begin
        xGrade:=Gradings.Grade;
        if Gradings.Failed=false then
        LastRemark:='PASS'
        else
        LastRemark:='FAIL';
        ExitDo:=true;
        end;
        end;

        until Gradings.Next = 0;


        end;

        end else begin
        Grade:='';
        //Remarks:='Not Done';
        end;
    end;


    procedure GetGradeStatus(var AvMarks: Decimal;var ProgCode: Code[20];var Unit: Code[20]) F: Boolean
    var
        LastGrade: Code[20];
        LastRemark: Code[20];
        ExitDo: Boolean;
        LastScore: Decimal;
        Gradings: Record UnknownRecord61599;
        Gradings2: Record UnknownRecord61599;
        GradeCategory: Code[20];
        GLabel: array [6] of Code[20];
        i: Integer;
        GLabel2: array [6] of Code[100];
        FStatus: Boolean;
        ProgrammeRec: Record UnknownRecord61511;
        Grd: Code[80];
    begin
        F:=false;

        GradeCategory:='';
        UnitsRR.Reset;
        UnitsRR.SetRange(UnitsRR."Programme Code",ProgCode);
        UnitsRR.SetRange(UnitsRR.Code,Unit);
        //UnitsRR.SETRANGE(UnitsRR."Stage Code","Course Registration".Stage);
        if UnitsRR.Find('-') then begin
        if UnitsRR."Default Exam Category"<>'' then begin
        GradeCategory:=UnitsRR."Default Exam Category";
        end else begin
        ProgrammeRec.Reset;
        if ProgrammeRec.Get(ProgCode) then
        GradeCategory:=ProgrammeRec."Exam Category";
        if GradeCategory='' then Error('Please note that you must specify Exam Category in Programme Setup');
        end;
        end;

        if AvMarks > 0 then begin
        Gradings.Reset;
        Gradings.SetRange(Gradings.Category,GradeCategory);
        LastGrade:='';
        LastRemark:='';
        LastScore:=0;
        if Gradings.Find('-') then begin
        ExitDo:=false;
        repeat
        LastScore:=Gradings."Up to";
        if AvMarks < LastScore then begin
        if ExitDo = false then begin
        Grd:=Gradings.Grade;
        F:=Gradings.Failed;
        ExitDo:=true;
        end;
        end;

        until Gradings.Next = 0;


        end;

        end else begin


        end;
    end;
}

