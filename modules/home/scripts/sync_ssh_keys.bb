#!/usr/bin/env bb

(require '[clojure.java.shell :refer [sh]]
         '[clojure.string :as str]
         '[clojure.java.io :as io]
         '[cheshire.core :as json])

(def item-name "Personal SSH-key")

(defn exit-err [msg]
  (binding [*out* *err*]
    (println "Error:" msg))
  (System/exit 1))

(defn bw [& args]
  (let [{:keys [exit out err]} (apply sh "bw" args)]
    (if (zero? exit)
      out
      (exit-err (str "Bitwarden CLI failed: " err)))))

(defn sync-keys []
  (let [session (System/getenv "BW_SESSION")]
    (when (str/blank? session)
      (exit-err "BW_SESSION environment variable is not set. Please run 'bw unlock' first."))

    (println (str "Searching for Bitwarden item '" item-name "'..."))
    (let [items-json (bw "list" "items" "--search" item-name)
          items (json/parse-string items-json true)
          item (first (filter #(= (:name %) item-name) items))]
      
      (if-not item
        (exit-err (str "Could not find Bitwarden item '" item-name "'"))
        (let [ssh-data (:sshKey item)
              ssh-dir (str (System/getProperty "user.home") "/.ssh")
              priv-key-path (str ssh-dir "/id_ed25519")
              pub-key-path (str ssh-dir "/id_ed25519.pub")]
          
          (if-not ssh-data
            (exit-err "Item found but it does not contain SSH key data.")
            (do
              (println "Ensuring ~/.ssh exists...")
              (.mkdirs (io/file ssh-dir))
              (sh "chmod" "700" ssh-dir)

              (println "Writing private key...")
              (spit priv-key-path (:privateKey ssh-data))
              (sh "chmod" "600" priv-key-path)

              (println "Writing public key...")
              (spit pub-key-path (:publicKey ssh-data))
              (sh "chmod" "644" pub-key-path)

              (println "Successfully synced SSH keys to" ssh-dir))))))))

(when (= *file* (System/getProperty "babashka.file"))
  (sync-keys))
