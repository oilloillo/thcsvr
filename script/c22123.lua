 
--红符「红色不夜城」
function c22123.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c22123.condition)
	e1:SetTarget(c22123.target)
	e1:SetOperation(c22123.operation)
	c:RegisterEffect(e1)
end
function c22123.cfilter(c)
	return c:IsSetCard(0x814) and c:IsFaceup()
end
function c22123.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c22123.cfilter,tp,LOCATION_MZONE,0,nil)==1
end
function c22123.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local z=Duel.GetMatchingGroup(c22123.cfilter,tp,LOCATION_MZONE,0,nil)
	local tc=z:GetFirst()
	local seq=tc:GetSequence()
	local g=Group.CreateGroup()
	if Duel.GetFieldCard(tp,LOCATION_MZONE,seq-1) then
		g:AddCard(Duel.GetFieldCard(tp,LOCATION_MZONE,seq-1))
	end
	if Duel.GetFieldCard(tp,LOCATION_MZONE,seq+1) then
		g:AddCard(Duel.GetFieldCard(tp,LOCATION_MZONE,seq+1))
	end
	if Duel.GetFieldCard(tp,LOCATION_SZONE,seq) then
		g:AddCard(Duel.GetFieldCard(tp,LOCATION_SZONE,seq))
	end
	if Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq) then
		g:AddCard(Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq))
	end
	if Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq) then
		g:AddCard(Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq))
	end
	if g:IsContains(e:GetHandler()) then
		g:RemoveCard(e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	local h=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,g:GetCount()-h)
end
function c22123.operation(e,tp,eg,ep,ev,re,r,rp)
	local z=Duel.GetMatchingGroup(c22123.cfilter,tp,LOCATION_MZONE,0,nil)
	local tc=z:GetFirst()
	local seq=tc:GetSequence()
	local g=Group.CreateGroup()
	if Duel.GetFieldCard(tp,LOCATION_MZONE,seq-1) then
		g:AddCard(Duel.GetFieldCard(tp,LOCATION_MZONE,seq-1))
	end
	if Duel.GetFieldCard(tp,LOCATION_MZONE,seq+1) then
		g:AddCard(Duel.GetFieldCard(tp,LOCATION_MZONE,seq+1))
	end
	if Duel.GetFieldCard(tp,LOCATION_SZONE,seq) then
		g:AddCard(Duel.GetFieldCard(tp,LOCATION_SZONE,seq))
	end
	if Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq) then
		g:AddCard(Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq))
	end
	if Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq) then
		g:AddCard(Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq))
	end
	if g:IsContains(e:GetHandler()) then
		g:RemoveCard(e:GetHandler()) end
	Duel.Destroy(g,REASON_EFFECT)
	local h=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if h<g:GetCount() then
		Duel.Draw(tp,g:GetCount()-h,REASON_EFFECT)
	end
end
