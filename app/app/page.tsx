import { verifySession } from "@/app/lib/dal";
import { Session } from "@/app/lib/definitions";
import { deleteSession } from "@/app/lib/session";
import Link from "next/link";

function Navbar({ session }: { session: Session }) {
  let connectionPartContent = null;
  if (session.isAuth) {
    connectionPartContent = (
      <li>
        Welcome, {session.user?.name}!{" "}
        <button onClick={deleteSession}>Logout</button>
      </li>
    );
  } else {
    connectionPartContent = (
      <li>
        <Link href="/signin">Sign in</Link>
      </li>
    );
  }
  return (
    <ul>
      <li>
        <Link href="/">Homepage</Link>
      </li>
      {connectionPartContent}
    </ul>
  );
}

export default async function Home() {
  const session = await verifySession();

  return (
    <div>
      <Navbar session={session}></Navbar>
      <h1>Hello, i&apos;m Chef Yum!</h1>
    </div>
  );
}
