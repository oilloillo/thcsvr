--✿红叶与丰收的象征✿
local M = c999311
local Mid = 999311
function M.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fus.AddFusionProcFun2(c, M.ffilter1, M.ffilter2, false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(M.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(M.spcon)
	e2:SetOperation(M.spop)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(999311,0))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1, 999311)
	e3:SetCost(M.eqcost)
	e3:SetTarget(M.eqtg)
	e3:SetOperation(M.eqop)
	c:RegisterEffect(e3)
end
M.DescSetName = 0xa2
function M.ffilter1(c)
	return c:IsFusionCode(999301) or c:IsFusionCode(23001)
end

function M.ffilter2(c)
	return c:IsFusionCode(999302) or c:IsFusionCode(23004)
end

function M.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end

function M.spfilter1(c, tp)
	local flag = Duel.GetLocationCountFromEx(tp, tp, c) < 1
	return (c:IsCode(999301) or c:IsCode(23001)) and c:IsCanBeFusionMaterial()
		and Duel.CheckReleaseGroup(tp, M.spfilter2, 1, c, tp, flag)
end

function M.spfilter2(c, tp, flag)
	if flag and Duel.GetLocationCountFromEx(tp, tp, c) < 1 then return false end
	return (c:IsCode(999302) or c:IsCode(23004)) and c:IsCanBeFusionMaterial()
end

function M.spcon(e, c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroup(tp, M.spfilter1, 1, nil, tp)
end

function M.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1 = Duel.SelectReleaseGroup(tp, M.spfilter1, 1, 1, nil, tp)
	local c1 = g1:GetFirst()
	local flag = Duel.GetLocationCountFromEx(tp, tp, c1) < 1

	local g2 = Duel.SelectReleaseGroup(tp, M.spfilter2, 1, 1, c1, tp, flag)
	g1:Merge(g2)
	c:SetMaterial(g1)
	
	Duel.Release(g1,REASON_COST)
end

function M.eqfilter(c)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	return mt and mt.DescSetName == 0xa2 and c:IsType(TYPE_SPELL) and not c:IsType(TYPE_CONTINUOUS)
end

function M.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end

function M.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(M.eqfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end

function M.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	
	if not Duel.IsExistingMatchingCard(M.eqfilter, tp, LOCATION_DECK, 0, 1, nil) then
		return 
	end
	if not Duel.IsExistingMatchingCard(Card.IsFaceup, tp, LOCATION_MZONE, 0, 1, nil) then
		return
	end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local eq=Duel.SelectMatchingCard(tp, M.eqfilter, tp, LOCATION_DECK, 0, 1, 1, nil):GetFirst()

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp, Card.IsFaceup, tp, LOCATION_MZONE, 0, 1, 1, nil):GetFirst()

	if not Duel.Equip(tp,eq,tc,true) then return end

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(M.eqlimit)
	eq:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999311,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(M.actcon)
	e2:SetCost(M.actcost)
	e2:SetTarget(M.acttg)
	e2:SetOperation(M.actop)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	eq:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	e3:SetValue(1)
	eq:RegisterEffect(e3)
end

function M.eqlimit(e,c)
	return true
end

function M.actcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and a==e:GetHandler():GetEquipTarget()) or (d and d==e:GetHandler():GetEquipTarget())
end

function M.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckActivateEffect(false,true,false)~=nil end
	local te=c:CheckActivateEffect(false,true,true)
	M[Duel.GetCurrentChain()]=te
end

function M.acttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local te=M[Duel.GetCurrentChain()]
	if chkc then
		local tg=te:GetTarget()
		return tg(e,tp,eg,ep,ev,re,r,rp,0,true)
	end
	if chk==0 then return true end
	if not te then return end
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end

function M.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local te=M[Duel.GetCurrentChain()]
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end