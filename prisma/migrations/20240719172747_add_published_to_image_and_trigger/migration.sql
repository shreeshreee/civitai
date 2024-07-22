ALTER TABLE "Image"
  ADD COLUMN "sortAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;
CREATE INDEX "Image_sortAt_idx" ON "Image" ("sortAt");

--

CREATE OR REPLACE FUNCTION update_image_sort_at()
  RETURNS TRIGGER AS
$$
BEGIN
  UPDATE "Image" SET "sortAt" = coalesce(NEW."publishedAt", "createdAt") WHERE "postId" = NEW."id";
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER post_published_at_change
  AFTER UPDATE OF "publishedAt" OR INSERT
  ON "Post"
  FOR EACH ROW
EXECUTE FUNCTION update_image_sort_at();

COMMENT ON FUNCTION update_image_sort_at() IS 'When a post is created or its publishedAt is updated, set sortAt for related images. If publishedAt is null, use createdAt.';

--

CREATE OR REPLACE FUNCTION update_new_image_sort_at()
  RETURNS TRIGGER AS
$$
BEGIN
  UPDATE "Image" i SET "sortAt" = coalesce(p."publishedAt", i."createdAt") FROM "Post" p WHERE NEW."postId" = p.id AND i."id" = NEW."id";
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER new_image_sort_at
  AFTER UPDATE OF "postId" OR INSERT
  ON "Image"
  FOR EACH ROW
EXECUTE FUNCTION update_new_image_sort_at();

COMMENT ON FUNCTION update_new_image_sort_at() IS 'When an image is created or its postId is updated, set sortAt based on the post. If publishedAt is null, use createdAt.'

--

-- -- Migration
-- UPDATE "Image" i SET "sortAt" = coalesce(p."publishedAt", i."createdAt") FROM "Post" p where i."postId" = p.id
