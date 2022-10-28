class PopularJobsData {
  final int? id;
  final String? companyName;
  final String? salary;
  final String? location;
  final String? iconUrl;
  final String? positionName;

  PopularJobsData(
      {this.id,
      this.companyName,
      this.salary,
      this.location,
      this.iconUrl,
      this.positionName});
}

final List<PopularJobsData> items = [
  PopularJobsData(
    id: 0,
    companyName: "Google",
    positionName: "Lead Product Manager",
    location: "Toronto, Canada",
    iconUrl: "assets/img/googleIcon.png",
    salary: "\$2500/m",
  ),
  PopularJobsData(
    id: 1,
    companyName: "Spotify",
    positionName: "Senior UI Designer",
    location: "Semarang, Indonesia",
    iconUrl: "assets/img/spotifyIcon.png",
    salary: "\$2500/m",
  ),
];

class RecentPostData {
  final int? id;
  final String? companyName;
  final String? salary;
  final String? conditionName;
  final String? location;
  final String? iconUrl;
  final String? positionName;

  RecentPostData(
      {this.id,
      this.companyName,
      this.salary,
      this.location,
      this.conditionName,
      this.iconUrl,
      this.positionName});
}

final List<RecentPostData> itemsRecent = [
  RecentPostData(
    id: 0,
    companyName: "Facebook",
    positionName: "UI / UX Designer",
    conditionName: "Full Time",
    iconUrl: "assets/img/facebookIcon.png",
    salary: "\$4500/m",
    location: "Semarang, Indonesia",
  ),
  RecentPostData(
    id: 1,
    companyName: "Spotify",
    positionName: "Product Designer",
    conditionName: "Remote",
    iconUrl: "assets/img/spotifyIcon.png",
    salary: "\$4500/m",
    location: "Purwokerto, Indonesia",
  ),
  RecentPostData(
    id: 2,
    companyName: "Netflix",
    positionName: "Mobile Developer",
    conditionName: "Full Time",
    iconUrl: "assets/img/netflixIcon.png",
    salary: "\$6000/m",
    location: "Kebumen, Indonesia",
  )
];
