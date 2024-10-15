import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Constitution Summaries',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: SummariesPage(),
    );
  }
}

class SummariesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB2DFDB), // Very Light Teal
              Color(0xFF80CBC4), // Light Teal
              Color(0xFF4DB6AC), // Mid Bright Teal
              Color(0xFF26A69A), // Bright Teal
            ],
            stops: [0.0, 0.33, 0.67, 1.0],
          ),
        ),
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(40),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildCard(context, 'PART I'),
            _buildCard(context, 'PART II'),
            _buildCard(context, 'PART III'),
            _buildCard(context, 'PART IV'),
            _buildCard(context, 'PART V'),
            _buildCard(context, 'PART VI'),
            _buildCard(context, 'PART VII'),
            _buildCard(context, 'PART VIII'),
            _buildCard(context, 'PART IX'),
            _buildCard(context, 'PART X'),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _getDetailsPage(title),
          ),
        );
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.0,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _getDetailsPage(String title) {
    switch (title) {
      case 'PART I':
        return PartIDetailsPage();
      case 'PART II':
        return PartIIDetailsPage();
      case 'PART III':
        return PartIIIDetailsPage();
      case 'PART IV':
        return PartIVDetailsPage();
      case 'PART V':
        return PartVDetailsPage();
      case 'PART VI':
        return PartVIDetailsPage();
      case 'PART VII':
        return PartVIIDetailsPage();
      case 'PART VIII':
        return PartVIIIDetailsPage();
      case 'PART IX':
        return PartIXDetailsPage();
      case 'PART X':
        return PartXDetailsPage();
      default:
        return Container(); // Default case
    }
  }
}

Widget _buildDetailsPage({required String title, required String content}) {
  return Scaffold(
    appBar: AppBar(
      title: Center(child: Text(title)),
      backgroundColor: Colors.teal,
    ),
    body: Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.teal[50]!,
            Colors.teal[100]!,
          ],
        ),
      ),
      child: Center( // Center the content vertically and horizontally
        child: Container(
          padding: EdgeInsets.all(20.0), // Add padding around the box
          decoration: BoxDecoration(
            color: Colors.white, // Box color
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: SingleChildScrollView( // Enable scrolling if content overflows
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Center align the column
              children: [
                SizedBox(height: 20),
                Text(
                  content,
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

// Individual Part Details Pages
class PartIDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildDetailsPage(
      title: 'Part I - Union and Territory',
      content: 'Part I of the Constitution of India defines the Union and its territory. India, also known as Bharat, is a Union of States, with its territories including States, Union Territories specified in the First Schedule, and any acquired territories. Parliament has the authority to admit or establish new States and can also alter the areas, boundaries, or names of existing States. Any changes require a Bill that must be introduced with the President\'s recommendation and referred to the State Legislature affected for feedback. Additionally, laws made under Articles 2 and 3 provide for necessary amendments to the First and Fourth Schedules and address supplemental matters such as parliamentary representation. These laws are not considered amendments to the Constitution under Article 368.',
    );
  }
}

class PartIIDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildDetailsPage(
      title: 'Part II - Citizenship',
      content: 'Part II of the Constitution of India addresses citizenship. It states that at the commencement of the Constitution, individuals with a domicile in India are considered citizens if they were born in India, have Indian parents, or have resided in India for at least five years. It also recognizes citizenship for those migrating from Pakistan, depending on their residency status and the date of migration. However, individuals who migrated from India to Pakistan after March 1, 1947, are not deemed citizens unless they return under specific conditions. Additionally, persons of Indian origin residing outside India can acquire citizenship if registered with Indian authorities. The Part stipulates that acquiring foreign citizenship results in the loss of Indian citizenship, but individuals recognized as citizens maintain their rights unless altered by Parliament, which retains the authority to regulate citizenship laws.',
    );
  }
}

class PartIIIDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildDetailsPage(
      title: 'Part III - Fundamental Rights',
      content: 'Part III of the Indian Constitution focuses on Fundamental Rights, which safeguard the rights and freedoms of citizens. It defines "the State" and establishes that any law inconsistent with these rights is void. Key rights include equality before the law (Article 14), prohibition of discrimination based on religion, race, caste, sex, or place of birth (Article 15), and equality of opportunity in public employment (Article 16). It also abolishes untouchability (Article 17) and titles (Article 18). Citizens are guaranteed freedoms of speech, assembly, movement, and the right to practice any profession (Article 19). Protection is provided against double jeopardy, self-incrimination, and unfair detention (Articles 20-22). Additionally, there are prohibitions on human trafficking and forced labor (Article 23). These rights form the core principles of individual liberty and social justice in India.',
    );
  }
}

class PartIVDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildDetailsPage(
      title: 'Part IV - Directive Principles of State Policy',
      content: 'Part IV of the Indian Constitution serves as guidelines for the State in governance and law-making. They emphasize the importance of creating a just social order that promotes the welfare of all citizens, ensuring social, economic, and political justice. Key principles include the right to livelihood, equal pay for equal work, just working conditions, free legal aid, and the promotion of education and economic interests for marginalized groups. The State is also tasked with organizing local self-governments (village panchayats), improving public health, safeguarding the environment, and protecting cultural heritage. These principles, although not enforceable by courts, are fundamental for the State\'s governance. Part IVA introduces Fundamental Duties, mandating every citizen to respect the Constitution, promote harmony, protect the environment, and strive for excellence. These duties aim to foster a sense of responsibility and unity among citizens, reinforcing their role in the nation\'s development.',
    );
  }
}

class PartVDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildDetailsPage(
      title: 'Part V - Union Executive and Governance in India',
      content: 'Part V of the Indian Constitution deals with the Union Executive, including the President, Vice-President, and the Council of Ministers. The President of India, who holds executive power, is elected by an electoral college comprising elected members of both houses of Parliament and the Legislative Assemblies of States. The President\'s term is five years, and they can be re-elected. The Vice-President serves as the ex-officio Chairman of the Rajya Sabha and assumes the President\'s duties in case of a vacancy or absence. The Council of Ministers, headed by the Prime Minister, aids and advises the President in executing their functions. The chapter also outlines the election, qualifications, terms, and powers of the President and Vice-President, including the process for impeachment and granting pardons.',
    );
  }
}

class PartVIDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildDetailsPage(
      title: 'Part VI - The States',
      content: 'Part VI of the Indian Constitution pertains to the governance of the states. It outlines the structure and powers of state governments, including the Governor, Chief Minister, and the Legislative Assembly and Council. The Governor is appointed by the President and serves as the representative of the central government in the state. The Chief Minister, elected by the Legislative Assembly, holds executive powers and is responsible for running the state government. The part also addresses the composition, powers, and functions of state legislatures, the establishment of legislative councils, and the Governor\'s role in legislative processes. Additionally, it covers the distribution of powers between the Union and the states, ensuring that both levels of government function effectively in the federal structure.',
    );
  }
}

class PartVIIDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildDetailsPage(
      title: 'Part VII - Administration of the States',
      content: 'Part VII originally dealt with the administration of the states listed in the First Schedule. However, it was repealed by the 7th Amendment in 1956. The amendment resulted in the restructuring of state boundaries and the creation of new states, highlighting the dynamic nature of federalism in India. Though Part VII is no longer in force, its historical context remains significant, as it reflects the evolving political landscape of India during the mid-20th century. The amendment also underscores the importance of adaptability in the constitutional framework to accommodate the diverse needs of the nation.',
    );
  }
}

class PartVIIIDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildDetailsPage(
      title: 'Part VIII - Administration of Union Territories',
      content: 'Part VIII of the Indian Constitution focuses on the administration of Union Territories (UTs). It establishes a framework for governance in UTs, which are regions administered directly by the Central Government. The part provides for the appointment of Administrators for each UT, who carry out the functions of the government. Some UTs may have legislatures, granting them limited self-governance, while others do not. The Constitution also allows for the incorporation of new UTs and specifies that the Central Government retains legislative powers over all UTs. The administrative framework aims to ensure effective governance while considering the unique needs and characteristics of each territory.',
    );
  }
}

class PartIXDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildDetailsPage(
      title: 'Part IX - Panchayati Raj System',
      content: 'Part IX deals with the Panchayati Raj system, which is a three-tier system of local self-governance in rural areas. It establishes the framework for the organization and powers of Panchayats, including the Gram Panchayat at the village level, the Panchayat Samiti at the block level, and the Zila Parishad at the district level. The part emphasizes the importance of decentralized governance, allowing local communities to participate in decision-making and development processes. Elections for Panchayati Raj institutions are mandated, ensuring that representatives are chosen by the people. This system aims to promote democracy, empower local bodies, and facilitate effective grassroots governance, enhancing accountability and responsiveness to community needs.',
    );
  }
}

class PartXDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildDetailsPage(
      title: 'Part X - Scheduled Areas and Tribal Areas',
      content: 'Part X of the Indian Constitution addresses the administration of Scheduled Areas and Tribal Areas, recognizing the unique cultural and social identity of tribal communities. It provides special provisions for the governance and protection of these areas to preserve the rights of indigenous peoples. The part empowers the Governor to declare Scheduled Areas and defines the legislative powers of the Parliament concerning these regions. It also mandates the establishment of autonomous councils for certain tribal areas, allowing for self-governance and representation. This part underscores the commitment to protecting the interests and rights of tribal populations while promoting their development and integration into the national mainstream.',
    );
  }
}
