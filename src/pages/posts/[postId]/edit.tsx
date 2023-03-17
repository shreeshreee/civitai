import { Container, Grid, Stack, Title } from '@mantine/core';
import { NotFound } from '~/components/AppLayout/NotFound';
import { EditPostControls } from '~/components/Post/Edit/EditPostControls';
import { EditPostDetail } from '~/components/Post/Edit/EditPostDetail';
import { EditPostImages } from '~/components/Post/Edit/EditPostImages';
import { useEditPostContext } from '~/components/Post/Edit/EditPostProvider';
import { EditPostReviews } from '~/components/Post/Edit/EditPostReviews';
import { EditPostTitle } from '~/components/Post/Edit/EditPostTitle';
import { PostEditComposite } from '~/components/Post/Edit/PostEditComposite';
import { PostEditLayout } from '~/components/Post/Edit/PostEditLayout';
import { ReorderImages } from '~/components/Post/Edit/ReorderImages';
import { useFeatureFlags } from '~/providers/FeatureFlagsProvider';

export default function PostEdit() {
  const features = useFeatureFlags();
  if (!features.posts) return <NotFound />;

  return (
    <Container>
      <PostEditComposite />
    </Container>
  );
}

PostEdit.getLayout = PostEditLayout;
